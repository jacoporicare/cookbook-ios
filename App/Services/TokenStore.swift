//
//  TokenStore.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 07.04.2022.
//

import KeychainAccess

/// Where the access token lives. Abstracted so the auth flow can be exercised
/// without touching the real Keychain.
protocol TokenStore: Sendable {
    var accessToken: String? { get }
    func setAccessToken(_ token: String?)
}

final class KeychainTokenStore: TokenStore, @unchecked Sendable {
    private enum Keys {
        static let accessToken = "accessToken"
    }

    private let keychain: Keychain

    init(service: String = "cz.jakubricar.zradelnik") {
        keychain = Keychain(service: service)
    }

    var accessToken: String? {
        keychain[Keys.accessToken]
    }

    func setAccessToken(_ token: String?) {
        keychain[Keys.accessToken] = token
    }
}

/// In-memory token storage, for previews and tests.
final class InMemoryTokenStore: TokenStore, @unchecked Sendable {
    private(set) var accessToken: String?

    init(accessToken: String? = nil) {
        self.accessToken = accessToken
    }

    func setAccessToken(_ token: String?) {
        accessToken = token
    }
}
