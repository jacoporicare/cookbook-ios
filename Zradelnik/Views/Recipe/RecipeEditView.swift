//
//  RecipeEditView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 08.04.2022.
//

import SwiftUI

struct RecipeEditView: View {
    @Environment(\.editMode) private var editMode

    var recipe: RecipeDetail
    let refetch: () -> Void

    var body: some View {
        RecipeForm(recipe: recipe, refetch: refetch, onSave: { _ in
            editMode?.animation().wrappedValue = .inactive
        }, onCancel: {
            editMode?.animation().wrappedValue = .inactive
        })
    }
}

#if DEBUG
struct RecipeEditView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RecipeEditView(recipe: RecipeDetail(from: recipeDetailPreviewData[0])) {}
        }
    }
}
#endif
