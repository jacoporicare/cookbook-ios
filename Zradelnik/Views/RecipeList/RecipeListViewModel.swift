//
//  RecipeListViewModel.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import Apollo
import Foundation

class RecipeListViewModel: ObservableObject {
    private var watcher: GraphQLQueryWatcher<RecipeListQuery>?

    @Published var recipes: LoadingStatus<[Recipe]> = .loading
    @Published var searchText = ""
    @Published var filteredRecipes: [Recipe]?

    func fetch() {
        if let watcher = watcher {
            watcher.refetch()
            return
        }

        watcher = Network.shared.apollo.watch(query: RecipeListQuery(), cachePolicy: .returnCacheDataAndFetch) { [weak self] result in
            switch result {
            case .success(let result):
                guard let data = result.data else { fallthrough }
                self?.recipes = .data(data.recipes.map { Recipe(from: $0) })
            case .failure:
                self?.recipes = .error
            }
        }
    }

    func submitSearchQuery() {
        if searchText.isEmpty {
            filteredRecipes = nil
        } else if case .data(let recipes) = recipes {
            filteredRecipes = recipes.filter {
                $0.title
                    .folding(options: .diacriticInsensitive, locale: .current)
                    .localizedCaseInsensitiveContains(searchText.folding(options: .diacriticInsensitive, locale: .current))
            }
        }
    }

    deinit {
        self.watcher?.cancel()
    }
}
