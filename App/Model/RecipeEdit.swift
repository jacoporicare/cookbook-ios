//
//  RecipeEdit.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 08.04.2022.
//

import API
import Foundation

struct RecipeEdit: Equatable {
    var title: String = ""
    var directions: String = ""
    var sideDish: String = ""
    var preparationTime: String = ""
    var servingCount: String = ""
    var ingredients: [Ingredient] = []
    var tags: [String] = []

    var isForInstantPot: Bool {
        get { tags.contains(Recipe.instantPotTag) }
        set {
            if newValue, !tags.contains(Recipe.instantPotTag) {
                tags.append(Recipe.instantPotTag)
            } else if !newValue, tags.contains(Recipe.instantPotTag) {
                tags.removeAll { $0 == Recipe.instantPotTag }
            }
        }
    }

    struct Ingredient: Equatable, Identifiable {
        var id = UUID().uuidString
        var name: String = ""
        var isGroup: Bool = false
        var amount: String = ""
        var amountUnit: String = ""
    }
}

extension RecipeEdit {
    static let `default` = RecipeEdit()
    static let defaultInstantPot = RecipeEdit(tags: [Recipe.instantPotTag])
}

extension RecipeEdit {
    init(from recipe: Recipe) {
        title = recipe.title
        directions = recipe.directions ?? ""
        sideDish = recipe.sideDish ?? ""
        preparationTime = recipe.preparationTimeRaw?.formatted() ?? ""
        servingCount = recipe.servingCountRaw?.formatted() ?? ""
        ingredients = recipe.ingredients.map { Ingredient(from: $0) }
        tags = recipe.tags
    }
}

extension RecipeEdit.Ingredient {
    init(from ingredient: Recipe.Ingredient) {
        id = ingredient.id
        name = ingredient.name
        isGroup = ingredient.isGroup
        amount = ingredient.amountRaw?.formatted() ?? ""
        amountUnit = ingredient.amountUnit ?? ""
    }
}

extension RecipeEdit {
    func toRecipeInput() -> RecipeInput {
        let preparationTime = Int(preparationTime)
        let servingCount = Int(servingCount)

        return RecipeInput(
            title: title,
            directions: !directions.isEmpty ? .some(directions) : nil,
            sideDish: !sideDish.isEmpty ? .some(sideDish) : nil,
            preparationTime: preparationTime != nil ? .some(preparationTime!) : nil,
            servingCount: servingCount != nil ? .some(servingCount!) : nil,
            ingredients: !ingredients.isEmpty
                ? .some(ingredients.filter { ingredient in
                    !ingredient.name.isEmpty
                }.map { ingredient in
                    let amount = Double(ingredient.amount.replacingOccurrences(of: ",", with: "."))

                    return IngredientInput(
                        amount: amount != nil ? .some(amount!) : nil,
                        amountUnit: !ingredient.amountUnit.isEmpty ? .some(ingredient.amountUnit) : nil,
                        name: ingredient.name,
                        isGroup: ingredient.isGroup ? true : false
                    )
                })
                : nil,
            tags: .some(tags)
        )
    }
}
