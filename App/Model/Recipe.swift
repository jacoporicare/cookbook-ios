//
//  Recipe.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import API
import Foundation

struct Recipe: Identifiable, Hashable {
    static let sousVideTag = "sous-vide"

    let id: String
    let title: String
    // Only the S3 object-key prefix; the renditions live under it (see Recipe+ImageURLs).
    let imageUrl: String?
    let directions: String?
    let sideDish: String?
    let preparationTime: String?
    let preparationTimeRaw: Int?
    let servingCount: String?
    let servingCountRaw: Int?
    let tags: [String]
    let ingredients: [Ingredient]
    let cookedHistory: [Cooked]

    var isForSousVide: Bool {
        tags.contains(Recipe.sousVideTag)
    }

    struct Ingredient: Identifiable, Hashable {
        let id: String
        let name: String
        let isGroup: Bool
        let amount: String?
        let amountRaw: Double?
        let amountUnit: String?
    }

    struct Cooked: Identifiable, Hashable {
        let id: String
        let date: Date
        let user: User?

        struct User: Identifiable, Hashable {
            let id: String
            let displayName: String
        }
    }
}

// MARK: - Search

extension Recipe {
    /// Diacritic- and case-insensitive match against the title and the ingredient names.
    /// This is the single definition of "matches a search term" in the app.
    func matches(_ term: String) -> Bool {
        let term = term.searchNormalized

        guard !term.isEmpty else { return true }

        return title.searchNormalized.contains(term)
            || ingredients.contains { $0.name.searchNormalized.contains(term) }
    }
}

private extension String {
    var searchNormalized: String {
        folding(options: [.diacriticInsensitive, .caseInsensitive], locale: zradelnikLocale)
    }
}

// MARK: - Mapping from the API

extension Recipe {
    init(from recipe: RecipeDetails) {
        self.id = recipe.id
        self.title = recipe.title
        self.imageUrl = recipe.imageUrl
        self.directions = recipe.directions
        self.sideDish = recipe.sideDish
        self.preparationTime = recipe.preparationTime?.formattedTime()
        self.preparationTimeRaw = recipe.preparationTime
        self.servingCount = recipe.servingCount?.formatted()
        self.servingCountRaw = recipe.servingCount
        self.tags = recipe.tags
        self.ingredients = recipe.ingredients.map { Ingredient(from: $0) }
        self.cookedHistory = recipe.cookedHistory.map { Cooked(from: $0) }
    }
}

extension Recipe.Ingredient {
    init(from ingredient: RecipeDetails.Ingredient) {
        self.id = ingredient.id
        self.name = ingredient.name
        self.isGroup = ingredient.isGroup
        self.amount = ingredient.amount?.formatted()
        self.amountRaw = ingredient.amount
        self.amountUnit = ingredient.amountUnit
    }
}

extension Recipe.Cooked {
    init(from cooked: RecipeDetails.CookedHistory) {
        self.id = cooked.id
        self.date = cooked.date
        self.user = cooked.user.map { User(from: $0) }
    }
}

extension Recipe.Cooked.User {
    init(from user: RecipeDetails.CookedHistory.User) {
        self.id = user.id
        self.displayName = user.displayName
    }
}

private extension Int {
    func formattedTime() -> String {
        let hours = Int(Double(self) / 60.0)
        let minutes = self % 60

        if hours > 0, minutes == 0 {
            return "\(hours) h"
        }

        if hours > 0, minutes > 0 {
            return "\(hours) h \(minutes) min"
        }

        return "\(minutes) min"
    }
}
