//
//  RecipeDetailView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 08.04.2022.
//

import MarkdownUI
import SwiftUI

struct RecipeDetailView: View {
    @Environment(\.editMode) private var editMode
    
    let recipe: RecipeDetail
    
    var body: some View {
        ScrollView {
            VStack {
                if let imageUrl = recipe.fullImageUrl {
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image.centerCropped()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 390)
                }
                
                VStack(spacing: 20) {
                    if let ingredients = recipe.ingredients, ingredients.count > 0 {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Ingredience")
                                .font(.title2)
                            
                            RecipeIngredientListView(ingredients: ingredients)
                                .padding(.horizontal)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Postup")
                            .font(.title2)
                        
                        Markdown(recipe.directions ?? "Kde nic tu nic.")
                    }
                }
                .padding()
            }
        }
        .toolbar {
            Button("Upravit") {
                editMode?.animation().wrappedValue = .active
            }
        }
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailView(recipe: recipeDetailPreviewData[0])
    }
}
