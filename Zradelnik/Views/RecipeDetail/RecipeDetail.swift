//
//  RecipeDetail.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 31.03.2022.
//

import SwiftUI

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
            
            VStack {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
