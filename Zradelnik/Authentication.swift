//
//  Authentication.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 06.04.2022.
//

import Foundation
import SwiftUI

class Authentication: ObservableObject {
    @Published private(set) var isLoggedIn = false
    @Published private(set) var accessToken: String?

    func updateAccessToken(accessToken: String?) {
        self.isLoggedIn = accessToken != nil
        self.accessToken = accessToken
    }
}
