//
//  RecipeDetailView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 08.04.2022.
//

import CachedAsyncImage
import MarkdownUI
import SwiftUI

struct RecipeDetailView: View {
    var recipe: Recipe
    
    @EnvironmentObject private var model: Model
    @Environment(\.editMode) private var editMode
    
    var body: some View {
        ScrollView {
            VStack {
                if let imageUrl = recipe.imageUrl {
                    CachedAsyncImage(url: URL(string: imageUrl), urlCache: .imageCache) { image in
                        image.centerCropped()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 390)
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    if recipe.preparationTime != nil || recipe.servingCount != nil {
                        ScrollView(.horizontal) {
                            HStack(spacing: 20) {
                                if let preparationTime = recipe.preparationTime {
                                    HStack {
                                        Text("Doba přípravy:")
                                            .foregroundColor(.gray)
                                        Text(preparationTime)
                                    }
                                }
                        
                                if let servingCount = recipe.servingCount {
                                    HStack {
                                        Text("Počet porcí:")
                                            .foregroundColor(.gray)
                                        Text(servingCount)
                                    }
                                }
                            
                                if let sideDish = recipe.sideDish {
                                    HStack {
                                        Text("Příloha:")
                                            .foregroundColor(.gray)
                                        Text(sideDish)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                            .font(.callout)
                        }
                    }
                    
                    if let ingredients = recipe.ingredients, ingredients.count > 0 {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Ingredience")
                                .font(.title2)
                            
                            RecipeIngredientListView(ingredients: ingredients)
                                .padding(.horizontal)
                        }
                        .padding(.horizontal)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Postup")
                            .font(.title2)
                        
                        Markdown(recipe.directions ?? "Kde nic tu nic.")
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
        .toolbar {
            if model.isLoggedIn {
                Button("Upravit") {
                    editMode?.animation().wrappedValue = .active
                }
            }
        }
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailView(recipe: Recipe(from: recipePreviewData[0]))
            .environmentObject(Model())
    }
}
