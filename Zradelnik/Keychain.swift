//
//  Keychain.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 07.04.2022.
//

import Foundation
import KeychainAccess

enum ZradelnikKeychain {
    static let instance = Keychain(service: "cz.jakubricar.zradelnik")
    
    static let accessTokenKey = "accessToken"
}
