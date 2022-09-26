//
//  Keychain.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 07.04.2022.
//

import KeychainAccess

enum ZKeychain {
    enum Keys {
        static let accessToken = "accessToken"
    }

    static let shared = Keychain(service: "cz.jakubricar.zradelnik")

    static var accessToken: String? {
        get { shared[Keys.accessToken] }
        set { shared[Keys.accessToken] = newValue }
    }
}
