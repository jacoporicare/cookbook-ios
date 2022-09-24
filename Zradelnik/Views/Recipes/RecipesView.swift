//
//  RecipesView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import SwiftUI

struct RecipesView: View {
    @EnvironmentObject private var model: Model
    @State private var showingRecipeForm = false

    var body: some View {
        LoadingContentView(status: model.loadingStatus, loadingText: "Načítání receptů...") {
            RecipesGridView(
                recipes: model.filteredRecipes,
                searchText: $model.searchText
            )
        } errorContent: { err in
            VStack {
                Text("Chyba")
                    .font(.title)

                Text("Recepty se nepodařilo načíst.")

                Button {
                    model.fetchRecipes()
                } label: {
                    Label("Zkusit znovu", systemImage: "arrow.clockwise")
                }
                .padding(.top)

                Text(err)
                    .font(.footnote.monospaced())
                    .padding(.top)
            }
        }
        .navigationTitle("Žrádelník")
        .navigationDestination(for: Recipe.self) { recipe in
            RecipeView(recipe: recipe)
        }
        .toolbar {
            if model.isLoggedIn {
                Button {
                    showingRecipeForm = true
                } label: {
                    Label("Nový recept", systemImage: "plus")
                }
            }

            Button {
                model.fetchRecipes()
            } label: {
                Label("Obnovit", systemImage: "arrow.clockwise")
            }
        }
        .sheet(isPresented: $showingRecipeForm) {
            NavigationStack {
                RecipeFormView { recipe in
                    model.fetchRecipes()
                    showingRecipeForm = false
                    model.recipeListStack.append(recipe)
                } onCancel: {
                    showingRecipeForm = false
                }
                .navigationTitle("Nový recept")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
