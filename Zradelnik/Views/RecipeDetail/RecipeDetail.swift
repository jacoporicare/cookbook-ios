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
                
                Markdown(recipe.directions ?? "Kde nic tu nic.")
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
