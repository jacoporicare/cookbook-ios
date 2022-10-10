//
//  CurrentUserStore.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 26.09.2022.
//

import Apollo
import Foundation

class CurrentUserStore: ObservableObject {
    @Published var loadingStatus: LoadingStatus = .loading
    @Published var userDisplayName: String?

    var isLoggedIn: Bool {
        ZKeychain.accessToken != nil
    }

    func setAccessToken(accessToken: String) {
        ZKeychain.accessToken = accessToken
        load()
    }

    func resetAccessToken() {
        ZKeychain.accessToken = nil
        userDisplayName = nil
    }

    func load() {
        loadingStatus = .loading

        Network.shared.apollo.fetch(query: MeQuery(), cachePolicy: .returnCacheDataAndFetch) { [weak self] result in
            switch result {
            case .success(let result):
                guard let displayName = result.data?.me.displayName else {
                    self?.loadingStatus = .error(result.errors?.first?.message ?? "No data, no error")
                    return
                }
                self?.loadingStatus = .data
                self?.userDisplayName = displayName
            case .failure(let error):
                self?.loadingStatus = .error(error.localizedDescription)
                self?.userDisplayName = "Chyba"
            }
        }
    }
}
