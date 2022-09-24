//
//  RecipeEditView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 08.04.2022.
//

import SwiftUI

struct RecipeEditView: View {
    var recipe: Recipe

    @EnvironmentObject private var model: Model
    @Environment(\.editMode) private var editMode

    var body: some View {
        RecipeFormView(recipe: recipe) { newRecipe in
            // No need to refetch, Apollo does it automatically after mutation based on ID
            model.recipeListStack[model.recipeListStack.endIndex - 1] = newRecipe
            editMode?.animation().wrappedValue = .inactive
        } onCancel: {
            editMode?.animation().wrappedValue = .inactive
        } onDelete: {
            model.fetchRecipes()
            model.recipeListStack.removeAll()
        }
    }
}

#if DEBUG
struct RecipeEditView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RecipeEditView(recipe: Recipe(from: recipePreviewData[0]))
        }
    }
}
#endif
