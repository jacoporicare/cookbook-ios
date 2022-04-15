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
    @Published var filteredRecipes: [Recipe]?
    
    var isLoggedIn: Bool {
        (try? ZKeychain.shared.contains(ZKeychain.Keys.accessToken)) ?? false
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
    func updateAccessToken(accessToken: String?) {
        ZKeychain.shared[ZKeychain.Keys.accessToken] = accessToken
        
        if accessToken != nil {
            fetchCurrentUser()
        } else {
            userDisplayName = nil
        }
    }
    
    private func fetchCurrentUser() {
        Network.shared.apollo.fetch(query: MeQuery()) { result in
            switch result {
            case .success(let result):
                guard let displayName = result.data?.me.displayName else { fallthrough }
                self.userDisplayName = displayName
            case .failure:
                self.userDisplayName = "Chyba"
            }
        }
    }
}

// MARK: - Recipes

extension Model {
    private func fetchRecipes() {
        recipesWatcher = Network.shared.apollo.watch(query: RecipesQuery(), cachePolicy: .returnCacheDataAndFetch) { [weak self] result in
            switch result {
            case .success(let result):
                guard let data = result.data else { fallthrough }
                self?.recipes = data.recipes.map { Recipe(from: $0) }
                self?.loadingStatus = .data
            case .failure:
                self?.loadingStatus = .error
            }
        }
    }
    
    func refetchRecipes() {
        guard let watcher = recipesWatcher else { return }
        loadingStatus = .loading
        watcher.refetch()
    }
    
    func submitSearchQuery() {
        if searchText.isEmpty {
            filteredRecipes = nil
        } else {
            filteredRecipes = recipes.filter {
                $0.title
                    .folding(options: .diacriticInsensitive, locale: .current)
                    .localizedCaseInsensitiveContains(searchText.folding(options: .diacriticInsensitive, locale: .current))
            }
        }
    }
}
