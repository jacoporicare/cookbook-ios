//
//  Authentication.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 06.04.2022.
//

import Foundation
import SwiftUI

class Authentication: ObservableObject {
    @Published private(set) var userDisplayName: String?
    
    var isLoggedIn: Bool {
        (try? ZradelnikKeychain.instance.contains(ZradelnikKeychain.accessTokenKey)) ?? false
    }
    
    init() {
        if isLoggedIn {
            fetchCurrentUser()
        }
    }

    func updateAccessToken(accessToken: String?) {
        ZradelnikKeychain.instance[ZradelnikKeychain.accessTokenKey] = accessToken
        
        if accessToken != nil {
            fetchCurrentUser()
        } else {
            userDisplayName = nil
        }
    }
    
    private func fetchCurrentUser() {
        Network.shared.apollo.fetch(query: MeQuery()) { result in
            switch result {
            case .success(let result):
                guard let displayName = result.data?.me.displayName else { fallthrough }
                self.userDisplayName = displayName
            case .failure:
                self.userDisplayName = "Chyba"
            }
        }
    }
}
