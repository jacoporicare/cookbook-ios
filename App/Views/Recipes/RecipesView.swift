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
    @EnvironmentObject private var routing: Routing
    @EnvironmentObject private var currentUserStore: CurrentUserStore
    @EnvironmentObject private var recipeStore: RecipeStore
    // AppStorage works weirdly - only the first change triggers render then it's stuck
//    @AppStorage("displayMode") private var displayMode = RecipesDisplayMode.grid
    @State private var displayMode = RecipesDisplayMode(rawValue: UserDefaults.standard.string(forKey: "displayMode") ?? RecipesDisplayMode.grid.rawValue) ?? RecipesDisplayMode.grid
    @State private var isRecipeFormPresented = false
    @State private var searchText = ""

    var filteredRecipes: [Recipe] {
        searchText.isEmpty
            ? recipeStore.recipes
            : recipeStore.recipes.filter {
                $0.title
                    .folding(options: .diacriticInsensitive, locale: .current)
                    .localizedCaseInsensitiveContains(searchText.folding(options: .diacriticInsensitive, locale: .current))
            }
    }

    var body: some View {
        LoadingContentView(status: recipeStore.loadingStatus, loadingText: "Načítání receptů...") {
            if displayMode == .grid {
                RecipesGrid(
                    recipes: filteredRecipes,
                    searchText: $searchText
                )
            } else {
                RecipesList(
                    recipes: filteredRecipes,
                    searchText: $searchText
                )
            }
        } errorContent: { err in
            VStack {
                Text("Chyba")
                    .font(.title)

                Text("Recepty se nepodařilo načíst.")

                Button {
                    recipeStore.reload()
                } label: {
                    Label("Zkusit znovu", systemImage: "arrow.clockwise")
                }
                .padding(.top)

                Text(err)
                    .font(.footnote.monospaced())
                    .padding(.top)
            }
        }
        .onAppear {
            recipeStore.watch()
        }
        .navigationTitle("Žrádelník")
        .navigationDestination(for: Recipe.self) { recipe in
            RecipeView(recipe: recipe)
        }
        .toolbar {
            if currentUserStore.isLoggedIn {
                Button {
                    isRecipeFormPresented = true
                } label: {
                    Label("Nový recept", systemImage: "plus")
                }
            }

            Menu {
                Button {
                    recipeStore.reload()
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
        .sheet(isPresented: $isRecipeFormPresented) {
            NavigationStack {
                RecipeForm { recipe in
                    recipeStore.reload()
                    isRecipeFormPresented = false
                    routing.recipeListStack.append(recipe)
                } onCancel: {
                    isRecipeFormPresented = false
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
