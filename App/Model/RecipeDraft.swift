//
//  RecipeDraft.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 08.04.2022.
//

import API
import Foundation

/// The editable shape of a recipe. Everything is a `String` because it is bound
/// straight to text fields; conversion back to typed values happens in `toRecipeInput`.
struct RecipeDraft: Equatable {
    var title: String = ""
    var directions: String = ""
    var sideDish: String = ""
    var preparationTime: String = ""
    var servingCount: String = ""
    var ingredients: [Ingredient] = []
    var tags: [String] = []

    var isForSousVide: Bool {
        get { tags.contains(Recipe.sousVideTag) }
        set {
            if newValue, !tags.contains(Recipe.sousVideTag) {
                tags.append(Recipe.sousVideTag)
            } else if !newValue, tags.contains(Recipe.sousVideTag) {
                tags.removeAll { $0 == Recipe.sousVideTag }
            }
        }
    }

    struct Ingredient: Equatable, Identifiable {
        var id = UUID().uuidString
        var name: String = ""
        var isGroup: Bool = false
        var amount: String = ""
        var amountUnit: String = ""

        /// An empty amount is allowed; a non-empty one has to parse as a number.
        var hasValidAmount: Bool {
            amount.isEmpty || Ingredient.parseAmount(amount) != nil
        }

        static func parseAmount(_ amount: String) -> Double? {
            Double(amount.replacingOccurrences(of: ",", with: "."))
        }
    }
}

// MARK: - Validation

extension RecipeDraft {
    var isValid: Bool {
        !title.isEmpty && ingredients.allSatisfy(\.hasValidAmount)
    }
}

// MARK: - Defaults

extension RecipeDraft {
    static let `default` = RecipeDraft()
    static let defaultSousVide = RecipeDraft(tags: [Recipe.sousVideTag])

    static func empty(isForSousVide: Bool) -> RecipeDraft {
        isForSousVide ? .defaultSousVide : .default
    }
}

// MARK: - Mapping from the domain model

extension RecipeDraft {
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

extension RecipeDraft.Ingredient {
    init(from ingredient: Recipe.Ingredient) {
        id = ingredient.id
        name = ingredient.name
        isGroup = ingredient.isGroup
        amount = ingredient.amountRaw?.formatted() ?? ""
        amountUnit = ingredient.amountUnit ?? ""
    }
}

// MARK: - Mapping to the API

extension RecipeDraft {
    func toRecipeInput() -> RecipeInput {
        RecipeInput(
            title: title,
            directions: directions.nullableInput,
            sideDish: sideDish.nullableInput,
            // Apollo 2 maps the GraphQL `Int` scalar to `Int32`, per the spec.
            preparationTime: Int32(preparationTime).nullableInput,
            servingCount: Int32(servingCount).nullableInput,
            ingredients: ingredients
                .filter { !$0.name.isEmpty }
                .map { $0.toIngredientInput() }
                .nullableInput,
            tags: .some(tags)
        )
    }
}

private extension RecipeDraft.Ingredient {
    func toIngredientInput() -> IngredientInput {
        IngredientInput(
            amount: RecipeDraft.Ingredient.parseAmount(amount).nullableInput,
            amountUnit: amountUnit.nullableInput,
            name: name,
            isGroup: .some(isGroup)
        )
    }
}

private extension String {
    /// Empty strings are sent as "not provided" rather than as an empty value.
    var nullableInput: GraphQLNullable<String> {
        isEmpty ? nil : .some(self)
    }
}

private extension Optional {
    var nullableInput: GraphQLNullable<Wrapped> {
        map { .some($0) } ?? nil
    }
}

private extension Array {
    var nullableInput: GraphQLNullable<[Element]> {
        isEmpty ? nil : .some(self)
    }
}
