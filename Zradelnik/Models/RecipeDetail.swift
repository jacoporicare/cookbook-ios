//
//  Recipe.swift
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
    var preparationTime: Int?
    var servingCount: Int?
    var ingredients: [Ingredient]?

    init(_ recipe: RecipeDetailQuery.Data.Recipe) {
        self.id = recipe.id
        self.title = recipe.title
        self.fullImageUrl = recipe.fullImageUrl
        self.directions = recipe.directions
        self.sideDish = recipe.sideDish
        self.preparationTime = recipe.preparationTime
        self.servingCount = recipe.servingCount
        self.ingredients = recipe.ingredients?.map { Ingredient($0) }
    }

    struct Ingredient: Identifiable, Decodable {
        var id: String
        var name: String
        var isGroup: Bool
        var amount: Double?
        var amountUnit: String?

        init(_ ingredient: RecipeDetailQuery.Data.Recipe.Ingredient) {
            self.id = ingredient.id
            self.name = ingredient.name
            self.isGroup = ingredient.isGroup
            self.amount = ingredient.amount
            self.amountUnit = ingredient.amountUnit
        }
    }
}
