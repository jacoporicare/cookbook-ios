//
//  RecipeEditView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 08.04.2022.
//

import SwiftUI

struct RecipeEditView: View {
    @Environment(\.editMode) var editMode
    
    @State private var draftRecipe = RecipeEdit.default
    
    init(recipe: RecipeDetail? = nil) {
        guard let recipe = recipe else { return }
        _draftRecipe = State(initialValue: RecipeEdit(recipe))
    }
    
    var body: some View {
        Form {
            Section("Základní informace") {
                TextField("Název", text: $draftRecipe.title)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            Group {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Uložit") {
                        editMode?.animation().wrappedValue = .inactive
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Zrušit") {
                        editMode?.animation().wrappedValue = .inactive
                    }
                }
            }
        }
    }
}

#if DEBUG
struct RecipeEditView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeEditView(recipe: recipeDetailPreviewData[0])
    }
}
#endif
