//
//  RecipeDetail.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 31.03.2022.
//

import SwiftUI
import MarkdownUI

struct RecipeView: View {
    @StateObject private var viewModel = RecipeViewModel()
    
    let id: String
    let title: String
    
    var body: some View {
        LoadingContent(status: viewModel.recipe) { recipe in
            loadedView(recipe: recipe)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetch(id: id)
        }
    }
    
    func loadedView(recipe: RecipeDetail) -> some View {
        ScrollView {
            VStack {
                if let imageUrl = recipe.fullImageUrl {
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                            .frame(height: 390)
                    }
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
    }
}

#if DEBUG
struct RecipeDetail_Previews: PreviewProvider {
    static let recipe = recipeDetailPreviewData[0]
    
    static var previews: some View {
        NavigationView {
            RecipeView(id: recipe.id, title: recipe.title)
                .loadedView(recipe: recipe)
                .navigationTitle(recipe.title)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
#endif
