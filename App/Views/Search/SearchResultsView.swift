//
//  SearchResultsView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 05.02.2026.
//

import SwiftUI

struct SearchResultsView: View {
    @Binding var searchText: String
    @Binding var isSearchActive: Bool
    var onDismiss: () -> Void

    @EnvironmentObject private var recipeStore: RecipeStore

    private let columnLayout = Array(repeating: GridItem(), count: 2)

    var filteredRecipes: [Recipe] {
        let allRecipes = recipeStore.recipes + recipeStore.sousVideRecipes.filter { sousVide in
            !recipeStore.recipes.contains { $0.id == sousVide.id }
        }

        guard !searchText.isEmpty else {
            return []
        }

        return allRecipes.filter {
            $0.title
                .folding(options: .diacriticInsensitive, locale: .current)
                .localizedCaseInsensitiveContains(searchText.folding(options: .diacriticInsensitive, locale: .current))
        }
        .sorted { $0.title.compare($1.title, locale: zradelnikLocale) == .orderedAscending }
    }

    var body: some View {
        NavigationStack {
            Group {
                if searchText.isEmpty {
                    ContentUnavailableView(
                        "Hledat recepty",
                        systemImage: "magnifyingglass",
                        description: Text("Zadejte hledaný výraz")
                    )
                } else if filteredRecipes.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                } else {
                    ScrollView {
                        LazyVGrid(columns: columnLayout) {
                            ForEach(filteredRecipes) { recipe in
                                NavigationLink(value: recipe) {
                                    RecipesGridItemView(recipe: recipe)
                                }
                            }
                        }
                        .padding()
                    }
                    .contentMargins(.bottom, 60, for: .scrollContent)
                }
            }
            .navigationTitle("Hledat")
            .searchable(text: $searchText, isPresented: $isSearchActive, prompt: "Hledat recept")
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeView(recipe: recipe)
            }
            .onChange(of: isSearchActive) { oldValue, newValue in
                if oldValue && !newValue {
                    onDismiss()
                }
            }
        }
    }
}
