//
//  Network.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import Foundation
import Apollo
import ApolloSQLite
import KeychainAccess

class Network {
    static let shared = Network()
    
    private(set) lazy var apollo = Network.createApollo()
    
    private static func createApollo() -> ApolloClient {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let documentsURL = URL(fileURLWithPath: documentsPath)
        let sqliteFileURL = documentsURL.appendingPathComponent("zradelnik_apollo_db.sqlite")
        
        let sqliteCache = try? SQLiteNormalizedCache(fileURL: sqliteFileURL)
        
        let store = ApolloStore(cache: sqliteCache ?? InMemoryNormalizedCache())
        
        let provider = NetworkInterceptorProvider(store: store)
        let baseUrl: String = try! Configuration.value(for: "API_BASE_URL")
        let transport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: URL(string: "https://\(baseUrl)/graphql")!)
        
        return ApolloClient(networkTransport: transport, store: store)
    }
}

class TokenAddingInterceptor: ApolloInterceptor {
    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
            if let token = ZradelnikKeychain.instance[ZradelnikKeychain.accessTokenKey] {
                request.addHeader(name: "Authorization", value: "Bearer \(token)")
            }
            
            chain.proceedAsync(request: request,
                               response: response,
                               completion: completion)
        }
}

class NetworkInterceptorProvider: DefaultInterceptorProvider {
    override func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        var interceptors = super.interceptors(for: operation)
        interceptors.insert(TokenAddingInterceptor(), at: 0)
        return interceptors
    }
}
