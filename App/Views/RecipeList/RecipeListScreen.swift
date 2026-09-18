//
//  RecipeListScreen.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import SwiftUI

struct RecipeListScreen: View {
    var isSousVideView = false

    @Environment(RecipeStore.self) private var recipeStore
    @Environment(CurrentUserStore.self) private var currentUserStore
    @Environment(Routing.self) private var routing
    @AppStorage("displayMode") private var displayMode = RecipesDisplayMode.grid

    @State private var isRecipeFormPresented = false

    private var recipeGroups: [RecipeGroup] {
        let recipes = isSousVideView ? recipeStore.sousVideRecipes : recipeStore.recipes
        return recipes.groupedByFirstLetter()
    }

    private var path: Binding<[RecipeRoute]> {
        @Bindable var routing = routing
        return isSousVideView ? $routing.sousVidePath : $routing.recipeListPath
    }

    var body: some View {
        LoadingContentView(status: recipeStore.loadingStatus, loadingText: "Načítání receptů...") {
            switch displayMode {
            case .grid:
                RecipeGridView(recipeGroups: recipeGroups, path: path)
            case .list:
                RecipeListView(recipeGroups: recipeGroups)
            }
        } errorContent: { error in
            RecipeListErrorView(error: error) {
                recipeStore.reload()
            }
        }
        .navigationTitle(isSousVideView ? "Sous-vide recepty" : "Žrádelník")
        .toolbar {
            if currentUserStore.isLoggedIn {
                Button {
                    isRecipeFormPresented = true
                } label: {
                    Label("Nový recept", systemImage: "plus")
                }
            }

            Menu {
                Button {
                    recipeStore.reload()
                } label: {
                    Label("Aktualizovat", systemImage: "arrow.clockwise")
                }

                Divider()

                Picker("Zobrazit jako", selection: $displayMode) {
                    Label("Mřížka", systemImage: "square.grid.2x2")
                        .tag(RecipesDisplayMode.grid)

                    Label("Seznam", systemImage: "list.bullet")
                        .tag(RecipesDisplayMode.list)
                }
            } label: {
                Label("Možnosti", systemImage: "ellipsis")
            }
        }
        .task {
            recipeStore.startWatching()
        }
        .navigationDestination(for: RecipeRoute.self) { route in
            RecipeDetailScreen(recipeId: route.recipeId)
        }
        .sheet(isPresented: $isRecipeFormPresented) {
            NavigationStack {
                RecipeFormScreen(isSousVideNewRecipe: isSousVideView) { recipe in
                    isRecipeFormPresented = false
                    // Open the recipe that was just created, on this tab's own stack.
                    if isSousVideView {
                        routing.sousVidePath.append(RecipeRoute(recipeId: recipe.id))
                    } else {
                        routing.recipeListPath.append(RecipeRoute(recipeId: recipe.id))
                    }
                } onCancel: {
                    isRecipeFormPresented = false
                }
                .navigationTitle("Nový recept")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

private struct RecipeListErrorView: View {
    let error: String
    let onRetry: () -> Void

    var body: some View {
        VStack {
            Text("Chyba")
                .font(.title)

            Text("Recepty se nepodařilo načíst.")

            Button(action: onRetry) {
                Label("Zkusit znovu", systemImage: "arrow.clockwise")
            }
            .padding(.top)

            Text(error)
                .font(.footnote.monospaced())
                .padding(.top)
        }
    }
}

#if DEBUG
#Preview("Grid") {
    NavigationStack {
        RecipeListScreen()
    }
    .previewStores()
}

#Preview("Sous-vide") {
    NavigationStack {
        RecipeListScreen(isSousVideView: true)
    }
    .previewStores()
}

#Preview("Logged in") {
    NavigationStack {
        RecipeListScreen()
    }
    .previewStores(isLoggedIn: true)
}

#Preview("Loading") {
    NavigationStack {
        RecipeListScreen()
    }
    .previewStores(status: .loading)
}

#Preview("Error") {
    NavigationStack {
        RecipeListScreen()
    }
    .previewStores(status: .error("Jejda"))
}
#endif
