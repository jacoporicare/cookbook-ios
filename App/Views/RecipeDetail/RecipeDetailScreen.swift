//
//  RecipeDetailScreen.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 08.04.2022.
//

import CachedAsyncImage
import MarkdownUI
import SwiftUI

/// Takes an id, not a `Recipe`: the recipe is read back from the store on every
/// render, so a mutation that lands in the Apollo cache shows up here without the
/// screen having to write anything back into the navigation path.
struct RecipeDetailScreen: View {
    let recipeId: String

    @Environment(RecipeStore.self) private var recipeStore
    @Environment(CurrentUserStore.self) private var currentUserStore
    @Environment(\.dismiss) private var dismiss

    @State private var isEditing = false
    @State private var isCookedDatePickerVisible = false
    @State private var isSaving = false
    @State private var isError = false

    var body: some View {
        if let recipe = recipeStore.recipe(id: recipeId) {
            if isEditing {
                RecipeFormScreen(recipe: recipe) { _ in
                    withAnimation { isEditing = false }
                } onCancel: {
                    withAnimation { isEditing = false }
                } onDelete: {
                    dismiss()
                }
                .navigationTitle(recipe.title)
                .navigationBarTitleDisplayMode(.inline)
            } else {
                detail(for: recipe)
            }
        } else {
            // The recipe was deleted while this screen was on the stack.
            ContentUnavailableView(
                "Recept nenalezen",
                systemImage: "questionmark.folder",
                description: Text("Recept byl nejspíš smazán.")
            )
        }
    }

    private func detail(for recipe: Recipe) -> some View {
        ScrollView {
            if let imageUrl = recipe.fullImageUrl {
                CachedAsyncImage(url: URL(string: imageUrl), urlCache: .imageCache) { image in
                    image.centerCropped()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 320)
            }

            VStack(alignment: .leading, spacing: 30) {
                RecipeActionButtons(
                    isCookedDatePickerVisible: $isCookedDatePickerVisible,
                    isUserLoggedIn: currentUserStore.isLoggedIn
                )

                if isCookedDatePickerVisible {
                    RecipeCookedDatePicker { date in
                        markCooked(recipe: recipe, date: date)
                    }
                }

                if recipe.isForSousVide {
                    RecipeSousVideInfo()
                }

                if let cooked = recipe.cookedHistory.last {
                    RecipeLastCooked(cooked: cooked, history: recipe.cookedHistory) { cookedId in
                        deleteCooked(recipe: recipe, cookedId: cookedId)
                    }
                }

                if recipe.preparationTime != nil || recipe.servingCount != nil || recipe.sideDish != nil {
                    RecipeBasicInfo(
                        preparationTime: recipe.preparationTime,
                        servingCount: recipe.servingCount,
                        sideDish: recipe.sideDish
                    )
                }

                if !recipe.ingredients.isEmpty {
                    RecipeIngredients(ingredients: recipe.ingredients)
                }

                VStack(alignment: .leading) {
                    Text("Postup")
                        .font(.title2)

                    Markdown(recipe.directions ?? "Kde nic tu nic.")
                }
            }
            .padding()
        }
        .navigationTitle(recipe.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if currentUserStore.isLoggedIn {
                Button("Upravit") {
                    withAnimation { isEditing = true }
                }
            }
        }
        .disabled(isSaving)
        .overlay {
            if isSaving {
                ZStack {
                    Color("ProgressOverlayColor")
                    ProgressView()
                }
            }
        }
        .alert("Nastala chyba.", isPresented: $isError) {}
    }

    // MARK: - Actions

    private func markCooked(recipe: Recipe, date: Date) {
        perform {
            try await recipeStore.markCooked(recipeId: recipe.id, date: date)
            withAnimation { isCookedDatePickerVisible = false }
        }
    }

    private func deleteCooked(recipe: Recipe, cookedId: String) {
        perform {
            try await recipeStore.deleteCooked(recipeId: recipe.id, cookedId: cookedId)
        }
    }

    private func perform(_ work: @escaping () async throws -> Void) {
        Task {
            isSaving = true
            defer { isSaving = false }

            do {
                try await work()
            } catch {
                isError = true
            }
        }
    }
}

#if DEBUG
#Preview("Sous-vide") {
    NavigationStack {
        RecipeDetailScreen(recipeId: previewRecipes[0].id)
    }
    .previewStores()
}

#Preview("Plain") {
    NavigationStack {
        RecipeDetailScreen(recipeId: previewRecipes[1].id)
    }
    .previewStores()
}

#Preview("Logged in") {
    NavigationStack {
        RecipeDetailScreen(recipeId: previewRecipes[0].id)
    }
    .previewStores(isLoggedIn: true)
}

#Preview("Deleted") {
    NavigationStack {
        RecipeDetailScreen(recipeId: "does-not-exist")
    }
    .previewStores()
}
#endif
