//
//  RecipeGroup.swift
//  Zradelnik
//

import Foundation

/// A section of the recipe list / grid, keyed by the recipe title's first letter.
struct RecipeGroup: Identifiable, Hashable {
    let id: String
    let recipes: [Recipe]
}
