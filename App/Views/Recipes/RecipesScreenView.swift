//
//  RecipesScreenView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import SwiftUI

struct RecipesScreenView: View {
    var isInstantPotView = false
    @Binding var shouldResetScrollPosition: Bool

    @EnvironmentObject private var routing: Routing
    @EnvironmentObject private var currentUserStore: CurrentUserStore
    @EnvironmentObject private var recipeStore: RecipeStore
    // AppStorage works weirdly - only the first change triggers render then it's stuck
//    @AppStorage("displayMode") private var displayMode = RecipesDisplayMode.grid
    @State private var displayMode = RecipesDisplayMode(rawValue: UserDefaults.standard.string(forKey: "displayMode") ?? RecipesDisplayMode.grid.rawValue) ?? RecipesDisplayMode.grid
    @State private var searchText = ""

    var recipeGroups: [RecipeGroup] {
        let recipes = isInstantPotView ? recipeStore.instantPotRecipes : recipeStore.recipes
        let filteredRecipes = searchText.isEmpty
            ? recipes
            : recipes.filter {
                $0.title
                    .folding(options: .diacriticInsensitive, locale: .current)
                    .localizedCaseInsensitiveContains(searchText.folding(options: .diacriticInsensitive, locale: .current))
            }

        return filteredRecipes.groupedByFirstLetter()
    }

    var body: some View {
        RecipesTemplateView(
            shouldResetScrollPosition: $shouldResetScrollPosition,
            displayMode: $displayMode,
            searchText: $searchText,
            recipeGroups: recipeGroups,
            isInstantPotView: isInstantPotView,
            loadingStatus: recipeStore.loadingStatus,
            isUserLoggedIn: currentUserStore.isLoggedIn,
            onReload: { recipeStore.reload() },
            onRecipeAdd: {
                recipeStore.reload()
                routing.recipeListStack.append($0)
            }
        )
        .onAppear {
            recipeStore.watch()
        }
        .navigationDestination(for: Recipe.self) { recipe in
            RecipeView(recipe: recipe)
        }
        .onChange(of: displayMode) { newValue in
            UserDefaults.standard.set(newValue.rawValue, forKey: "displayMode")
        }
    }
}
