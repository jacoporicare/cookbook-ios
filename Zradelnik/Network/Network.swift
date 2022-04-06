//
//  Network.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import Foundation
import Apollo
import ApolloSQLite

class Network {
    static let shared = Network()
    
    private(set) lazy var apollo = Network.createApollo()
    
    private static func createApollo() -> ApolloClient {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let documentsURL = URL(fileURLWithPath: documentsPath)
        let sqliteFileURL = documentsURL.appendingPathComponent("zradelnik_apollo_db.sqlite")
        
        let sqliteCache = try? SQLiteNormalizedCache(fileURL: sqliteFileURL)
        
        let store = ApolloStore(cache: sqliteCache ?? InMemoryNormalizedCache())
        
        let provider = DefaultInterceptorProvider(store: store)
        let baseUrl: String = try! Configuration.value(for: "API_BASE_URL")
        let transport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: URL(string: "https://\(baseUrl)/graphql")!)
        
        return ApolloClient(networkTransport: transport, store: store)
    }
}
