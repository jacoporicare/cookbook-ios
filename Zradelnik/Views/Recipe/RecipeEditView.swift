//
//  RecipeEditView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 08.04.2022.
//

import SwiftUI

struct RecipeEditView: View {
    @Environment(\.editMode) var editMode
    
    let recipe: RecipeDetail
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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

struct RecipeEditView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeEditView(recipe: recipeDetailPreviewData[0])
    }
}
