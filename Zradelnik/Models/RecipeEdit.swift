//
//  RecipeEdit.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 08.04.2022.
//

import Foundation

struct RecipeEdit {
    var title: String = ""
    var directions: String = ""
    var sideDish: String = ""
    var preparationTime: String = ""
    var servingCount: String = ""
    var ingredients: [Ingredient] = []
    var tags: [String] = []

    struct Ingredient {
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
    init(from recipe: RecipeDetail) {
        title = recipe.title
        directions = recipe.directions ?? ""
        sideDish = recipe.sideDish ?? ""
        preparationTime = recipe.preparationTime ?? ""
        servingCount = recipe.servingCount ?? ""
        ingredients = recipe.ingredients.map { Ingredient(from: $0) }
    }
}

extension RecipeEdit.Ingredient {
    init(from ingredient: RecipeDetail.Ingredient) {
        name = ingredient.name
        isGroup = ingredient.isGroup
        amount = ingredient.amount ?? ""
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
                ? ingredients.map { ingredient in
                    IngredientInput(
                        amount: Double(ingredient.amount),
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
