//
//  Keychain.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 07.04.2022.
//

import Foundation
import KeychainAccess

enum ZKeychain {
    static let shared = Keychain(service: "cz.jakubricar.zradelnik")

    enum Keys {
        static let accessToken = "accessToken"
    }
}
