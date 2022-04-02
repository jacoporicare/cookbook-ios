//
//  RecipeList.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import SwiftUI

struct RecipeList: View {
    @StateObject private var viewModel = RecipeListViewModel()
    
    let columnLayout = Array(repeating: GridItem(), count: 2)
    
    let title = "Žrádelník"
    
    var body: some View {
        LoadingContent(status: viewModel.status) { recipes in
            loadedView(recipes: recipes)
        }
        .navigationTitle(title)
        .onAppear {
            viewModel.fetch()
        }
    }
    
    func loadedView(recipes: [Recipe]) -> some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 20) {
                ForEach(recipes) { recipe in
                    NavigationLink {
                        RecipeDetail(id: recipe.id, title: recipe.title)
                    } label: {
                        RecipeListItem(recipe: recipe)
                    }
                }
            }
            .scenePadding()
        }
    }
}

struct RecipeList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeList()
                .loadedView(recipes: recipePreviewData)
                .navigationTitle("Žrádelník")
        }
    }
}
