//
//  AuthService.swift
//  Zradelnik
//

import API
import Apollo
import Foundation

enum AuthError: LocalizedError {
    case invalidCredentials
    case noData(String?)

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            "Neplatný uživatel nebo heslo."
        case .noData(let message):
            message ?? "Server nevrátil žádná data."
        }
    }
}

/// Token handling plus the two auth-related operations. Both login paths (the web
/// flow and the native form) end at `storeAccessToken`.
protocol AuthService {
    var accessToken: String? { get }

    /// The native username/password flow. Returns the access token.
    func logIn(username: String, password: String) async throws -> String

    func storeAccessToken(_ token: String)
    func clearAccessToken()

    func loadDisplayName() async throws -> String
}

final class ApolloAuthService: AuthService {
    private let client: ApolloClient
    private let tokenStore: any TokenStore

    init(client: ApolloClient, tokenStore: any TokenStore) {
        self.client = client
        self.tokenStore = tokenStore
    }

    var accessToken: String? {
        tokenStore.accessToken
    }

    func storeAccessToken(_ token: String) {
        tokenStore.setAccessToken(token)
    }

    func clearAccessToken() {
        tokenStore.setAccessToken(nil)
    }

    func logIn(username: String, password: String) async throws -> String {
        let response = try await client.perform(mutation: LoginMutation(username: username, password: password))

        guard let token = response.data?.login.token else {
            throw AuthError.invalidCredentials
        }

        return token
    }

    func loadDisplayName() async throws -> String {
        let response = try await client.fetch(query: MeQuery(), cachePolicy: .networkFirst)

        guard let displayName = response.data?.me.displayName else {
            throw AuthError.noData(response.errors?.first?.message)
        }

        return displayName
    }
}
