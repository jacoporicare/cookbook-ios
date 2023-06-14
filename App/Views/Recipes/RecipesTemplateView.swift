//
//  RecipesTemplateView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 09.06.2023.
//

import SwiftUI

enum RecipesDisplayMode: String {
    case grid
    case list
}

struct RecipeGroup: Identifiable {
    let id: String
    let recipes: [Recipe]
}

struct RecipesTemplateView: View {
    @Binding var shouldResetScrollPosition: Bool
    @Binding var displayMode: RecipesDisplayMode
    @Binding var searchText: String

    let recipeGroups: [RecipeGroup]
    let isInstantPotView: Bool
    let loadingStatus: LoadingStatus
    let isUserLoggedIn: Bool

    let onReload: Callback
    let onRecipeAdd: (Recipe) -> Void

    @State private var isRecipeFormPresented = false

    var body: some View {
        LoadingContentView(status: loadingStatus, loadingText: "Načítání receptů...") {
            if displayMode == .grid {
                RecipesGridView(
                    recipeGroups: recipeGroups,
                    searchText: $searchText,
                    shouldResetScrollPosition: $shouldResetScrollPosition
                )
            } else {
                RecipesListView(
                    recipeGroups: recipeGroups,
                    searchText: $searchText,
                    shouldResetScrollPosition: $shouldResetScrollPosition
                )
            }
        } errorContent: { err in
            VStack {
                Text("Chyba")
                    .font(.title)

                Text("Recepty se nepodařilo načíst.")

                Button {
                    onReload()
                } label: {
                    Label("Zkusit znovu", systemImage: "arrow.clockwise")
                }
                .padding(.top)

                Text(err)
                    .font(.footnote.monospaced())
                    .padding(.top)
            }
        }
        .navigationTitle(isInstantPotView ? "Instant Pot recepty" : "Žrádelník")
        .toolbar {
            if isUserLoggedIn {
                Button {
                    isRecipeFormPresented = true
                } label: {
                    Label("Nový recept", systemImage: "plus")
                }
            }

            Menu {
                Button {
                    onReload()
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
                Label("Možnosti", systemImage: "ellipsis.circle")
            }
        }
        .sheet(isPresented: $isRecipeFormPresented) {
            NavigationStack {
                RecipeFormScreenView(isInstantPotNewRecipe: isInstantPotView) { recipe in
                    isRecipeFormPresented = false
                    onRecipeAdd(recipe)
                } onCancel: {
                    isRecipeFormPresented = false
                }
                .navigationTitle("Nový recept")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#if DEBUG
struct RecipesTemplateView_Previews: PreviewProvider {
    private static let recipeGroups = recipePreviewData
        .map { Recipe(from: $0.fragments.recipeDetails) }
        .groupedByFirstLetter()

    static var previews: some View {
        Group {
            NavigationStack {
                RecipesTemplateView(
                    shouldResetScrollPosition: .constant(false),
                    displayMode: .constant(.list),
                    searchText: .constant(""),
                    recipeGroups: recipeGroups,
                    isInstantPotView: false,
                    loadingStatus: .data,
                    isUserLoggedIn: false,
                    onReload: {},
                    onRecipeAdd: { _ in }
                )
            }
            .previewDisplayName("List")

            NavigationStack {
                RecipesTemplateView(
                    shouldResetScrollPosition: .constant(false),
                    displayMode: .constant(.grid),
                    searchText: .constant(""),
                    recipeGroups: recipeGroups,
                    isInstantPotView: false,
                    loadingStatus: .data,
                    isUserLoggedIn: false,
                    onReload: {},
                    onRecipeAdd: { _ in }
                )
            }
            .previewDisplayName("Grid")

            NavigationStack {
                RecipesTemplateView(
                    shouldResetScrollPosition: .constant(false),
                    displayMode: .constant(.grid),
                    searchText: .constant(""),
                    recipeGroups: recipeGroups,
                    isInstantPotView: true,
                    loadingStatus: .data,
                    isUserLoggedIn: false,
                    onReload: {},
                    onRecipeAdd: { _ in }
                )
            }
            .previewDisplayName("Instant Pot")

            NavigationStack {
                RecipesTemplateView(
                    shouldResetScrollPosition: .constant(false),
                    displayMode: .constant(.grid),
                    searchText: .constant(""),
                    recipeGroups: recipeGroups,
                    isInstantPotView: false,
                    loadingStatus: .data,
                    isUserLoggedIn: true,
                    onReload: {},
                    onRecipeAdd: { _ in }
                )
            }
            .previewDisplayName("Logged In")

            NavigationStack {
                RecipesTemplateView(
                    shouldResetScrollPosition: .constant(false),
                    displayMode: .constant(.grid),
                    searchText: .constant(""),
                    recipeGroups: recipeGroups,
                    isInstantPotView: false,
                    loadingStatus: .loading,
                    isUserLoggedIn: true,
                    onReload: {},
                    onRecipeAdd: { _ in }
                )
            }
            .previewDisplayName("Loading")

            NavigationStack {
                RecipesTemplateView(
                    shouldResetScrollPosition: .constant(false),
                    displayMode: .constant(.grid),
                    searchText: .constant(""),
                    recipeGroups: recipeGroups,
                    isInstantPotView: false,
                    loadingStatus: .error("Jejda"),
                    isUserLoggedIn: true,
                    onReload: {},
                    onRecipeAdd: { _ in }
                )
            }
            .previewDisplayName("Error")
        }
    }
}
#endif
