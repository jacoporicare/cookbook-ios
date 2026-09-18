//
//  RecipeIngredients.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 03.11.2022.
//

import SwiftUI

struct RecipeIngredients: View {
    let ingredients: [Recipe.Ingredient]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Ingredience")
                .font(.title2)

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
            .padding(.horizontal)
        }
    }
}

#if DEBUG
#Preview {
    RecipeIngredients(ingredients: previewRecipes[0].ingredients)
        .padding()
}
#endif
