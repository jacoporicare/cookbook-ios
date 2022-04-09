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

    func fetch() {
        if let watcher = watcher {
            watcher.refetch()
            return
        }

        watcher = Network.shared.apollo.watch(query: RecipeListQuery(), cachePolicy: .returnCacheDataAndFetch) { [weak self] result in
            switch result {
            case .success(let result):
                guard let data = result.data else { fallthrough }
                self?.recipes = .data(data.recipes.map { Recipe($0) })
            case .failure:
                self?.recipes = .error
            }
        }
    }

    deinit {
        self.watcher?.cancel()
    }
}
