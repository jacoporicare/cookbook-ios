//
//  Routing.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 26.09.2022.
//

import Foundation
import Observation

/// A pushed recipe. Only the id travels in the navigation path - the recipe itself
/// is read back from `RecipeStore`, so a pushed screen always shows current data
/// and never has to write back into the path to refresh itself.
struct RecipeRoute: Hashable {
    let recipeId: String
}

@MainActor
@Observable
final class Routing {
    /// Each tab keeps its own stack, so switching tabs preserves where you were.
    var recipeListPath: [RecipeRoute] = []
    var sousVidePath: [RecipeRoute] = []
    var searchPath: [RecipeRoute] = []

    func popToRoot(_ tab: AppTab) {
        switch tab {
        case .recipes:
            recipeListPath = []
        case .sousVideRecipes:
            sousVidePath = []
        case .search:
            searchPath = []
        case .settings:
            break
        }
    }
}
