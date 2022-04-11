//
//  RecipeViewModel.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import Apollo
import Foundation

class RecipeViewModel: ObservableObject {
    private var watcher: GraphQLQueryWatcher<RecipeDetailQuery>?

    @Published var recipe: LoadingStatus<RecipeDetail> = .loading

    func fetch(id: String) {
        if let watcher = watcher {
            watcher.refetch()
            return
        }
        
        watcher = Network.shared.apollo.watch(query: RecipeDetailQuery(id: id), cachePolicy: .returnCacheDataAndFetch) { [weak self] result in
            switch result {
            case .success(let result):
                guard let recipe = result.data?.recipe else { fallthrough }
                self?.recipe = .data(RecipeDetail(from: recipe))
            case .failure:
                self?.recipe = .error
            }
        }
    }

    deinit {
        self.watcher?.cancel()
    }
}
