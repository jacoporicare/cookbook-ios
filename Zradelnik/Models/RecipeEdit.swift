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

    static let `default` = RecipeEdit()

    struct Ingredient {
        var name: String = ""
        var isGroup: Bool = false
        var amount: String = ""
        var amountUnit: String = ""

        init(_ ingredient: RecipeDetail.Ingredient) {
            name = ingredient.name
            isGroup = ingredient.isGroup
            amount = ingredient.amount?.formatted() ?? ""
            amountUnit = ingredient.amountUnit ?? ""
        }
    }
}

extension RecipeEdit {
    init(from recipe: RecipeDetail) {
        title = recipe.title
        directions = recipe.directions ?? ""
        sideDish = recipe.sideDish ?? ""
        preparationTime = recipe.preparationTime ?? ""
        servingCount = recipe.servingCount ?? ""
        ingredients = recipe.ingredients?.map { Ingredient($0) } ?? []
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
