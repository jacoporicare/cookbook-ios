//
//  RecipeDetail.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 31.03.2022.
//

import SwiftUI
import MarkdownUI

struct RecipeDetail: View {
    @StateObject private var viewModel = RecipeDetailViewModel()
    
    let id: String
    let title: String
    
    var body: some View {
        LoadingContent(status: viewModel.status) { recipe in
            loadedView(recipe: recipe)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetch(id)
        }
    }
    
    func loadedView(recipe: DetailedRecipe) -> some View {
        ScrollView {
            VStack {
                if let imageUrl = recipe.fullImageUrl {
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                            .frame(height: 300)
                    }
                }
                
                VStack(spacing: 20) {
                    if let ingredients = recipe.ingredients, ingredients.count > 0 {
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
                                                        Text(amount.formatted())
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
                    
                    VStack(alignment: .leading) {
                        Text("Postup")
                            .font(.title2)
                        
                        Markdown(recipe.directions ?? "Kde nic tu nic.")
                    }
                }
                .scenePadding()
            }
        }
    }
}

struct RecipeDetail_Previews: PreviewProvider {
    static let recipe = recipeDetailPreviewData[0]
    
    static var previews: some View {
        NavigationView {
            RecipeDetail(id: recipe.id, title: recipe.title)
                .loadedView(recipe: recipe)
                .navigationTitle(recipe.title)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
