//
//  Recipe.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import Foundation

struct Recipe: Identifiable, Decodable, Hashable {
    static let instantPotTag = "Instant Pot"

    let id: String
    let title: String
    let gridImageUrl: String?
    let listImageUrl: String?
    let fullImageUrl: String?
    let directions: String?
    let sideDish: String?
    let preparationTime: String?
    let preparationTimeRaw: Int?
    let servingCount: String?
    let servingCountRaw: Int?
    let tags: [String]
    let ingredients: [Ingredient]
    let cookedHistory: [Cooked]

    var isForInstantPot: Bool {
        tags.contains(Recipe.instantPotTag)
    }

    struct Ingredient: Identifiable, Decodable, Hashable {
        let id: String
        let name: String
        let isGroup: Bool
        let amount: String?
        let amountRaw: Double?
        let amountUnit: String?
    }

    struct Cooked: Identifiable, Decodable, Hashable {
        let id: String
        let date: Date
        let user: User

        struct User: Identifiable, Decodable, Hashable {
            let id: String
            let displayName: String
        }
    }
}

extension Recipe {
    init(from recipe: RecipeDetails) {
        self.id = recipe.id
        self.title = recipe.title
        self.gridImageUrl = recipe.gridImageUrl
        self.listImageUrl = recipe.listImageUrl
        self.fullImageUrl = recipe.fullImageUrl
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
        self.user = User(from: cooked.user)
    }
}

extension Recipe.Cooked.User {
    init(from user: RecipeDetails.CookedHistory.User) {
        self.id = user.id
        self.displayName = user.displayName
    }
}

extension Recipe {
    func matches(_ string: String) -> Bool {
        string.isEmpty
            || title.localizedCaseInsensitiveContains(string)
            || ingredients.contains { $0.name.localizedCaseInsensitiveContains(string) }
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
