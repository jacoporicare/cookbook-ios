//
//  RecipeList.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import SwiftUI

struct RecipeList: View {
    @EnvironmentObject private var authentication: Authentication
    @StateObject private var viewModel = RecipeListViewModel()

    let columnLayout = Array(repeating: GridItem(), count: 2)

    var body: some View {
        LoadingContent(status: viewModel.recipes) { recipes in
            loadedView(recipes: recipes)
        }
        .navigationTitle("Žrádelník")
        .onAppear {
            viewModel.fetch()
        }
        .toolbar {
            Button {
//                showingSettings.toggle()
            } label: {
                Label("Nový recept", systemImage: "plus")
            }
        }
    }

    func loadedView(recipes: [Recipe]) -> some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columnLayout) {
                ForEach(recipes) { recipe in
                    NavigationLink {
                        RecipeView(id: recipe.id, title: recipe.title)
                    } label: {
                        RecipeListItem(recipe: recipe)
                    }
                }
            }
            .padding()
        }
    }
}

#if DEBUG
struct RecipeList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeList()
                .loadedView(recipes: recipePreviewData)
                .navigationTitle("Žrádelník")
                .toolbar {
                    Button {} label: {
                        Label("Profil", systemImage: "gear")
                    }
                }
        }
    }
}
#endif
