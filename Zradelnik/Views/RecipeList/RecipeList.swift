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
    @State private var showingRecipeForm = false
    @State private var activeRecipeId: String?

    let columnLayout = Array(repeating: GridItem(), count: 2)

    var body: some View {
        LoadingContent(status: viewModel.recipes) { recipes in
            loadedView(recipes: viewModel.filteredRecipes ?? recipes)
        }
        .navigationTitle("Žrádelník")
        .onAppear {
            viewModel.fetch()
        }
        .toolbar {
            if authentication.isLoggedIn {
                Button {
                    showingRecipeForm = true
                } label: {
                    Label("Nový recept", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingRecipeForm) {
            NavigationView {
                RecipeForm {
                    viewModel.fetch()
                } onSave: { id in
                    showingRecipeForm = false
                    activeRecipeId = id
                } onCancel: {
                    showingRecipeForm = false
                }
                .navigationTitle("Nový recept")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }

    func loadedView(recipes: [Recipe]) -> some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columnLayout) {
                ForEach(recipes) { recipe in
                    let isActive = Binding<Bool>(
                        get: { activeRecipeId == recipe.id },
                        set: { activeRecipeId = $0 ? recipe.id : nil }
                    )

                    NavigationLink(isActive: isActive) {
                        RecipeView(id: recipe.id, title: recipe.title)
                    } label: {
                        RecipeListItem(recipe: recipe)
                    }
                }
            }
            .padding()
        }
        .searchable(text: $viewModel.searchText, prompt: "Hledat recept")
        .onReceive(viewModel.$searchText) { _ in
            viewModel.submitSearchQuery()
        }
    }
}

#if DEBUG
struct RecipeList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeList()
                .loadedView(recipes: recipePreviewData.map { Recipe(from: $0) })
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
