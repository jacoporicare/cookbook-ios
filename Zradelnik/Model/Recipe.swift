//
//  Recipe.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import Foundation

struct Recipe: Identifiable, Decodable {
    var id: String
    var title: String
    var imageUrl: String?
    var directions: String?
    var sideDish: String?
    var preparationTime: String?
    var preparationTimeRaw: Int?
    var servingCount: String?
    var servingCountRaw: Int?
    var ingredients: [Ingredient]
    
    struct Ingredient: Identifiable, Decodable {
        var id: String
        var name: String
        var isGroup: Bool
        var amount: String?
        var amountRaw: Double?
        var amountUnit: String?
    }
}

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
        self.ingredients = recipe.ingredients?.map { Ingredient(from: $0) } ?? []
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

extension Recipe {
    func matches(_ string: String) -> Bool {
        string.isEmpty ||
        title.localizedCaseInsensitiveContains(string) ||
        ingredients.contains {
            $0.name.localizedCaseInsensitiveContains(string)
        }
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
