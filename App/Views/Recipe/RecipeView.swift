//
//  RecipeView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 31.03.2022.
//

import SwiftUI

struct RecipeView: View {
    let recipe: Recipe

    @Environment(\.editMode) private var editMode

    var body: some View {
        Group {
            if editMode?.wrappedValue == .inactive {
                RecipeDetailScreenView(recipe: recipe)
            } else {
                RecipeEditView(recipe: recipe)
            }
        }
        .navigationTitle(recipe.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
