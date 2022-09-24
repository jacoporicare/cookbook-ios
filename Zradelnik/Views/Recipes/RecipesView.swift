//
//  RecipesView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import SwiftUI

enum RecipesDisplayMode: String {
    case grid
    case list
}

struct RecipesView: View {
    @EnvironmentObject private var model: Model
    // AppStorage works weirdly - only the first change triggers render then it's stuck
//    @AppStorage("displayMode") private var displayMode = RecipesDisplayMode.grid
    @State private var displayMode = RecipesDisplayMode(rawValue: UserDefaults.standard.string(forKey: "displayMode") ?? RecipesDisplayMode.grid.rawValue) ?? RecipesDisplayMode.grid
    @State private var showingRecipeForm = false

    var body: some View {
        LoadingContentView(status: model.loadingStatus, loadingText: "Načítání receptů...") {
            if displayMode == .grid {
                RecipesGridView(
                    recipes: model.filteredRecipes,
                    searchText: $model.searchText
                )
            } else {
                RecipesListView(
                    recipes: model.filteredRecipes,
                    searchText: $model.searchText
                )
            }
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

            Menu {
                Button {
                    model.fetchRecipes()
                } label: {
                    Label("Aktualizovat", systemImage: "arrow.clockwise")
                }

                Divider()

                Picker("Zobrazit jako", selection: $displayMode) {
                    Label("Mřížka", systemImage: "square.grid.2x2")
                        .tag(RecipesDisplayMode.grid)

                    Label("Seznam", systemImage: "list.bullet")
                        .tag(RecipesDisplayMode.list)
                }
            } label: {
                Label("Možnosti", systemImage: "ellipsis.circle")
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
        .onChange(of: displayMode) { newValue in
            UserDefaults.standard.set(newValue.rawValue, forKey: "displayMode")
        }
    }
}
