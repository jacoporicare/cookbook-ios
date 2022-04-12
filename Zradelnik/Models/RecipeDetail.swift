//
//  RecipeDetail.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import Foundation

struct RecipeDetail: Identifiable, Decodable {
    var id: String
    var title: String
    var fullImageUrl: String?
    var directions: String?
    var sideDish: String?
    var preparationTime: String?
    var servingCount: String?
    var ingredients: [Ingredient]

    struct Ingredient: Identifiable, Decodable {
        var id: String
        var name: String
        var isGroup: Bool
        var amount: String?
        var amountUnit: String?
    }
}

extension RecipeDetail {
    init(from recipe: RecipeDetailQuery.Data.Recipe) {
        self.id = recipe.id
        self.title = recipe.title
        self.fullImageUrl = recipe.fullImageUrl
        self.directions = recipe.directions
        self.sideDish = recipe.sideDish
        self.preparationTime = recipe.preparationTime?.formattedTime()
        self.servingCount = recipe.servingCount?.formatted()
        self.ingredients = recipe.ingredients?.map { Ingredient(from: $0) } ?? []
    }
}

extension RecipeDetail.Ingredient {
    init(from ingredient: RecipeDetailQuery.Data.Recipe.Ingredient) {
        self.id = ingredient.id
        self.name = ingredient.name
        self.isGroup = ingredient.isGroup
        self.amount = ingredient.amount?.formatted()
        self.amountUnit = ingredient.amountUnit
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
