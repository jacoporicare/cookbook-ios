//
//  Model.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 15.04.2022.
//

import Apollo
import Foundation

class Model: ObservableObject {
    @Published var userDisplayName: String?

    @Published var loadingStatus: LoadingStatus = .loading
    @Published var recipes: [Recipe] = []
    @Published var searchText = ""
    @Published var recipeListStack: [Recipe] = []

    var isLoggedIn: Bool {
        (try? ZKeychain.shared.contains(ZKeychain.Keys.accessToken)) ?? false
    }

    var filteredRecipes: [Recipe] {
        searchText.isEmpty
            ? recipes
            : recipes.filter {
                $0.title
                    .folding(options: .diacriticInsensitive, locale: .current)
                    .localizedCaseInsensitiveContains(searchText.folding(options: .diacriticInsensitive, locale: .current))
            }
    }

    private var recipesWatcher: GraphQLQueryWatcher<RecipesQuery>?

    init() {
        if isLoggedIn {
            fetchCurrentUser()
        }

        fetchRecipes()
    }

    deinit {
        self.recipesWatcher?.cancel()
    }
}

// MARK: - Authentication

extension Model {
    func setAccessToken(accessToken: String) {
        ZKeychain.shared[ZKeychain.Keys.accessToken] = accessToken
        fetchCurrentUser()
    }

    func resetAccessToken() {
        ZKeychain.shared[ZKeychain.Keys.accessToken] = nil
        userDisplayName = nil
    }

    private func fetchCurrentUser() {
        Network.shared.apollo.fetch(query: MeQuery(), cachePolicy: .returnCacheDataAndFetch) { [weak self] result in
            switch result {
            case .success(let result):
                guard let displayName = result.data?.me.displayName else { fallthrough }
                self?.userDisplayName = displayName
            case .failure:
                self?.userDisplayName = "Chyba"
            }
        }
    }
}

// MARK: - Recipes

extension Model {
    var lastFetchDate: Date? {
        get {
            return UserDefaults.standard.object(forKey: "lastFetchDate") as? Date
        }
        set(date) {
            UserDefaults.standard.set(date, forKey: "lastFetchDate")
        }
    }

    func fetchRecipes(silent: Bool = false) {
        if let watcher = recipesWatcher {
            if !silent {
                loadingStatus = .loading
            }

            watcher.refetch()
        } else {
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
    }

    // Called from background app refresh - Apollo updates the cache and the watcher above is triggered automatically
    func fetchRecipesAsync() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            Network.shared.apollo.fetch(query: RecipesQuery(), cachePolicy: .fetchIgnoringCacheData) { result in
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
