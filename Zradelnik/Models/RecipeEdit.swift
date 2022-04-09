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
    var preparationTime: Int = 0
    var servingCount: Int = 0
    var ingredients: [Ingredient] = []
    var tags: [String] = []

    static let `default` = RecipeEdit()

    init() {}

    init(from recipe: RecipeDetail) {
        title = recipe.title
        directions = recipe.directions ?? ""
        sideDish = recipe.sideDish ?? ""
        preparationTime = recipe.preparationTime ?? 0
        servingCount = recipe.servingCount ?? 0
        ingredients = recipe.ingredients?.map { Ingredient($0) } ?? []
    }

    func toRecipeInput() -> RecipeInput {
        RecipeInput(
            title: title,
            directions: !directions.isEmpty ? directions : nil,
            sideDish: !sideDish.isEmpty ? sideDish : nil,
            preparationTime: preparationTime > 0 ? preparationTime : nil,
            servingCount: servingCount > 0 ? servingCount : nil,
            ingredients: !ingredients.isEmpty
                ? ingredients.map { ingredient in
                    IngredientInput(
                        amount: ingredient.amount > 0 ? ingredient.amount : nil,
                        amountUnit: !ingredient.amountUnit.isEmpty ? ingredient.amountUnit : nil,
                        name: ingredient.name,
                        isGroup: ingredient.isGroup ? true : false
                    )
                }
                : nil,
            tags: nil
        )
    }

    struct Ingredient {
        var name: String = ""
        var isGroup: Bool = false
        var amount: Double = 0
        var amountUnit: String = ""

        init(_ ingredient: RecipeDetail.Ingredient) {
            name = ingredient.name
            isGroup = ingredient.isGroup
            amount = ingredient.amount ?? 0
            amountUnit = ingredient.amountUnit ?? ""
        }
    }
}
