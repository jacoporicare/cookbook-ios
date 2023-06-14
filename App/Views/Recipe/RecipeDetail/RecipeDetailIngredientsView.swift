//
//  RecipeDetailIngredientsView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 03.11.2022.
//

import SwiftUI

struct RecipeDetailIngredientsView: View {
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

struct RecipeDetailIngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailIngredientsView(ingredients: [
            .init(id: "1", name: "brambory", isGroup: false, amount: "10", amountRaw: 10, amountUnit: "kg"),
            .init(id: "2", name: "sůl", isGroup: false, amount: nil, amountRaw: nil, amountUnit: "špetka"),
            .init(id: "4", name: "Skupina", isGroup: true, amount: nil, amountRaw: nil, amountUnit: nil),
            .init(id: "3", name: "pepř", isGroup: false, amount: nil, amountRaw: nil, amountUnit: nil)
        ])
    }
}
