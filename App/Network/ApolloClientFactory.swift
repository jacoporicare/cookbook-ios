//
//  ApolloClientFactory.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import Apollo
import ApolloAPI
import ApolloSQLite
import Foundation

extension Notification.Name {
    /// Posted when the server rejects the access token. `CurrentUserStore` listens
    /// for this so the UI does not keep pretending the user is still signed in.
    static let zradelnikUnauthenticated = Notification.Name("cz.jakubricar.Zradelnik.unauthenticated")
}

enum ApolloClientFactory {
    /// Builds the one client the services share. Called from the composition root;
    /// nothing else should need to construct a client.
    static func make(tokenStore: any TokenStore) -> ApolloClient {
        let sqliteFileURL = URL.cachesDirectory.appending(path: "zradelnik_apollo_db.sqlite")
        let sqliteCache = try? SQLiteNormalizedCache(fileURL: sqliteFileURL)

        let store = ApolloStore(cache: sqliteCache ?? InMemoryNormalizedCache())

        // Deliberately fatal: a build with no API_BASE_URL cannot talk to anything,
        // and failing at launch with a readable message beats a confusing 404 later.
        guard let baseUrl: String = try? Configuration.value(for: "API_BASE_URL") else {
            fatalError("API_BASE_URL is missing from Info.plist - check Configuration/*.xcconfig")
        }

        let endpointURL = URL(string: "https://\(baseUrl)/graphql")!

        let transport = RequestChainNetworkTransport(
            urlSession: URLSession(configuration: .default),
            interceptorProvider: NetworkInterceptorProvider(tokenStore: tokenStore),
            store: store,
            endpointURL: endpointURL
        )

        return ApolloClient(networkTransport: transport, store: store)
    }
}

/// Adds the bearer token to every outgoing request. An `HTTPInterceptor` because it
/// only ever touches headers on the raw `URLRequest`.
struct AuthorizationHeaderInterceptor: HTTPInterceptor {
    let tokenStore: any TokenStore

    func intercept(
        request: URLRequest,
        next: NextHTTPInterceptorFunction
    ) async throws -> HTTPResponse {
        var request = request

        if let token = tokenStore.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return try await next(request)
    }
}

/// Clears the token when the server says it is no longer valid. A `GraphQLInterceptor`
/// because it inspects the parsed GraphQL errors, not the HTTP status.
struct UnauthenticatedInterceptor: GraphQLInterceptor {
    let tokenStore: any TokenStore

    func intercept<Request: GraphQLRequest>(
        request: Request,
        next: NextInterceptorFunction<Request>
    ) async throws -> InterceptorResultStream<Request> {
        await next(request).map { result in
            if result.result.errors?.contains(where: { $0.message == "Unauthenticated" }) == true {
                tokenStore.setAccessToken(nil)
                NotificationCenter.default.post(name: .zradelnikUnauthenticated, object: nil)
            }

            return result
        }
    }
}

struct NetworkInterceptorProvider: InterceptorProvider {
    let tokenStore: any TokenStore

    func graphQLInterceptors<Operation: GraphQLOperation>(
        for operation: Operation
    ) -> [any GraphQLInterceptor] {
        DefaultInterceptorProvider.shared.graphQLInterceptors(for: operation)
            + [UnauthenticatedInterceptor(tokenStore: tokenStore)]
    }

    func httpInterceptors<Operation: GraphQLOperation>(
        for operation: Operation
    ) -> [any HTTPInterceptor] {
        [AuthorizationHeaderInterceptor(tokenStore: tokenStore)]
            + DefaultInterceptorProvider.shared.httpInterceptors(for: operation)
    }
}
