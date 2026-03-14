//
//  RecipesScreenView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import SwiftUI

struct RecipesScreenView: View {
    var isSousVideView = false
    @Binding var shouldResetScrollPosition: Bool

    @EnvironmentObject private var routing: Routing
    @EnvironmentObject private var currentUserStore: CurrentUserStore
    @EnvironmentObject private var recipeStore: RecipeStore
    @AppStorage("displayMode") private var displayMode = RecipesDisplayMode.grid

    var recipeGroups: [RecipeGroup] {
        let recipes = isSousVideView ? recipeStore.sousVideRecipes : recipeStore.recipes
        return recipes.groupedByFirstLetter()
    }

    var body: some View {
        RecipesTemplateView(
            shouldResetScrollPosition: $shouldResetScrollPosition,
            displayMode: $displayMode,
            recipeGroups: recipeGroups,
            isSousVideView: isSousVideView,
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
    }
}
