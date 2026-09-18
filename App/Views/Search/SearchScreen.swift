//
//  SearchScreen.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 05.02.2026.
//

import SwiftUI

struct SearchScreen: View {
    @Binding var searchText: String
    @Binding var isSearchActive: Bool
    let onDismiss: () -> Void

    @Environment(RecipeStore.self) private var recipeStore

    private let columnLayout = Array(repeating: GridItem(), count: 2)

    /// Uses `Recipe.matches`, the same definition the rest of the app searches by.
    private var filteredRecipes: [Recipe] {
        guard !searchText.isEmpty else { return [] }

        return recipeStore.recipes
            .filter { $0.matches(searchText) }
            .sortedByTitle()
    }

    var body: some View {
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
                            NavigationLink(value: RecipeRoute(recipeId: recipe.id)) {
                                RecipeGridCard(recipe: recipe)
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
        .navigationDestination(for: RecipeRoute.self) { route in
            RecipeDetailScreen(recipeId: route.recipeId)
        }
        .onChange(of: isSearchActive) { oldValue, newValue in
            if oldValue, !newValue {
                onDismiss()
            }
        }
    }
}

#if DEBUG
#Preview("Empty") {
    NavigationStack {
        SearchScreen(searchText: .constant(""), isSearchActive: .constant(true), onDismiss: {})
    }
    .previewStores()
}

#Preview("Results") {
    NavigationStack {
        SearchScreen(searchText: .constant("ho"), isSearchActive: .constant(true), onDismiss: {})
    }
    .previewStores()
}

#Preview("No results") {
    NavigationStack {
        SearchScreen(searchText: .constant("xyz"), isSearchActive: .constant(true), onDismiss: {})
    }
    .previewStores()
}
#endif
