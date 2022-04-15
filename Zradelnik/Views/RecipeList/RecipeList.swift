//
//  RecipeList.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import SwiftUI

struct RecipeList: View {
    @EnvironmentObject private var model: Model
    @State private var showingRecipeForm = false
    @State private var activeRecipeId: String?

    private let columnLayout = Array(repeating: GridItem(), count: 2)

    var body: some View {
        LoadingContent(status: model.loadingStatus) {
            loadedView(recipes: model.filteredRecipes ?? model.recipes)
        }
        .navigationTitle("Žrádelník")
        .toolbar {
            if model.isLoggedIn {
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
                    model.refetchRecipes()
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
                        RecipeView(recipe: recipe)
                    } label: {
                        RecipeListItem(recipe: recipe)
                    }
                }
            }
            .padding()
        }
        .searchable(text: $model.searchText, prompt: "Hledat recept")
        .onReceive(model.$searchText) { _ in
            model.submitSearchQuery()
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
