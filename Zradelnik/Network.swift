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
        // 1. You'll have to figure out where to store your SQLite file.
        // A reasonable place is the user's Documents directory in your sandbox.
        // In any case, create a file URL for your file:
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let documentsURL = URL(fileURLWithPath: documentsPath)
        let sqliteFileURL = documentsURL.appendingPathComponent("zradelnik_apollo_db.sqlite")
        
        // 2. Use that file URL to instantiate the SQLite cache:
        let sqliteCache = try? SQLiteNormalizedCache(fileURL: sqliteFileURL)
        
        // 3. And then instantiate an instance of `ApolloStore` with the cache you've just created:
        let store = ApolloStore(cache: sqliteCache ?? InMemoryNormalizedCache())
        
        let provider = DefaultInterceptorProvider(store: store)
        let transport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: URL(string: "https://api-test.zradelnik.eu/graphql")!)
        
        // 4. Assuming you've set up your `networkTransport` instance elsewhere,
        // pass the store you just created into your `ApolloClient` initializer,
        // and you're now set up to use the SQLite cache for persistent storage
        return ApolloClient(networkTransport: transport, store: store)
    }
}
