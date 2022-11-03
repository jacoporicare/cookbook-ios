//
//  RecipeDetailLastCookedDate.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 03.11.2022.
//

import SwiftUI

struct RecipeDetailLastCookedDate: View {
    var cooked: Recipe.Cooked

    var body: some View {
        HStack {
            Text("Naposledy uvařeno:")
                .foregroundColor(.gray)
            Text(cooked.date.formatted(date: .abbreviated, time: .omitted))
            Text("(\(cooked.user.displayName))")
        }
        .font(.callout)
    }
}

struct RecipeDetailLastCookedDate_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailLastCookedDate(
            cooked: .init(
                date: Date(),
                user: .init(
                    id: "1",
                    displayName: "Kubik"
                )
            )
        )
    }
}
