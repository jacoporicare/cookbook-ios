//
//  Model.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 15.04.2022.
//

import Apollo
import Foundation

class RecipeStore: ObservableObject {
    @Published var loadingStatus: LoadingStatus = .loading
    @Published var recipes: [Recipe] = []
    
    var instantPotRecipes: [Recipe] {
        recipes.filter { $0.isForInstantPot }
    }

    private var recipesWatcher: GraphQLQueryWatcher<RecipesQuery>?

    deinit {
        self.recipesWatcher?.cancel()
    }

    var lastFetchDate: Date? {
        get { UserDefaults.standard.object(forKey: "lastFetchDate") as? Date }
        set { UserDefaults.standard.set(newValue, forKey: "lastFetchDate") }
    }

    func watch() {
        if recipesWatcher != nil {
            return
        }

        recipesWatcher = Network.shared.apollo.watch(query: RecipesQuery(), cachePolicy: .returnCacheDataAndFetch) { [weak self] result in
            switch result {
            case .success(let result):
                guard let data = result.data else {
                    self?.loadingStatus = .error(result.errors?.first?.message ?? "No data, no error")
                    return
                }
                self?.recipes = data.recipes.map { Recipe(from: $0.fragments.recipeDetails) }
                self?.loadingStatus = .data
                self?.lastFetchDate = Date()
            case .failure(let error):
                self?.loadingStatus = .error(error.localizedDescription)
            }
        }
    }

    func reload(silent: Bool = false) {
        guard let recipesWatcher else { return }

        if !silent {
            loadingStatus = .loading
        }

        recipesWatcher.refetch()
    }

    // Called from background app refresh and list pull-to-update refreshable
    // Apollo updates the cache and the watcher above is triggered automatically
    func loadAsync() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            Network.shared.apollo.fetch(
                query: RecipesQuery(),
                cachePolicy: .fetchIgnoringCacheData,
                queue: .global(qos: .background)
            ) { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
