//
//  RecipeEdit.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 08.04.2022.
//

import Foundation

struct RecipeEdit: Equatable {
    var title: String = ""
    var directions: String = ""
    var sideDish: String = ""
    var preparationTime: String = ""
    var servingCount: String = ""
    var ingredients: [Ingredient] = []
    var tags: [String] = []

    struct Ingredient: Equatable, Identifiable {
        let id = UUID().uuidString
        var name: String = ""
        var isGroup: Bool = false
        var amount: String = ""
        var amountUnit: String = ""
    }
}

extension RecipeEdit {
    static let `default` = RecipeEdit()
}

extension RecipeEdit {
    init(from recipe: Recipe) {
        title = recipe.title
        directions = recipe.directions ?? ""
        sideDish = recipe.sideDish ?? ""
        preparationTime = recipe.preparationTimeRaw?.formatted() ?? ""
        servingCount = recipe.servingCountRaw?.formatted() ?? ""
        ingredients = recipe.ingredients.map { Ingredient(from: $0) }
    }
}

extension RecipeEdit.Ingredient {
    init(from ingredient: Recipe.Ingredient) {
        name = ingredient.name
        isGroup = ingredient.isGroup
        amount = ingredient.amountRaw?.formatted() ?? ""
        amountUnit = ingredient.amountUnit ?? ""
    }
}

extension RecipeEdit {
    func toRecipeInput() -> RecipeInput {
        RecipeInput(
            title: title,
            directions: !directions.isEmpty ? directions : nil,
            sideDish: !sideDish.isEmpty ? sideDish : nil,
            preparationTime: Int(preparationTime),
            servingCount: Int(servingCount),
            ingredients: !ingredients.isEmpty
                ? ingredients.filter { ingredient in
                    !ingredient.name.isEmpty
                }.map { ingredient in
                    IngredientInput(
                        amount: Double(ingredient.amount.replacingOccurrences(of: ",", with: ".")),
                        amountUnit: !ingredient.amountUnit.isEmpty ? ingredient.amountUnit : nil,
                        name: ingredient.name,
                        isGroup: ingredient.isGroup ? true : false
                    )
                }
                : nil,
            tags: nil
        )
    }
}
