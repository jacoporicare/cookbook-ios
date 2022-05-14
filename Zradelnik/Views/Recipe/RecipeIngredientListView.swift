//
//  RecipeIngredientListView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 05.04.2022.
//

import SwiftUI

struct RecipeIngredientListView: View {
    var ingredients: [Recipe.Ingredient]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(ingredients) { ingredient in
                if ingredient.isGroup {
                    Text(ingredient.name)
                        .bold()
                } else {
                    VStack(alignment: .leading) {
                        Text(ingredient.name)

                        if ingredient.amount != nil || ingredient.amountUnit != nil {
                            HStack {
                                if let amount = ingredient.amount {
                                    Text(amount)
                                }
                                if let amountUnit = ingredient.amountUnit {
                                    Text(amountUnit)
                                }
                            }
                            .font(.callout)
                            .foregroundColor(.gray)
                        }
                    }
                }

                Divider()
            }
        }
    }
}

#if DEBUG
struct RecipeDetailIngredients_Previews: PreviewProvider {
    static var previews: some View {
        RecipeIngredientListView(ingredients: recipePreviewData[0].ingredients?.map { Recipe.Ingredient(from: $0) } ?? [])
    }
}
#endif
