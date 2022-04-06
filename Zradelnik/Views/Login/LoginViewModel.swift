//
//  LoginViewModel.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 05.04.2022.
//

import Foundation
import SwiftUI

final class LoginViewModel: ObservableObject {
    @Published var loggingIn = false
    @Published var error = false
    @Published var username = ""
    @Published var password = ""
    
    var loginDisabled: Bool {
        username.isEmpty || password.isEmpty
    }
    
    func login(completion: @escaping (String) -> Void) {
        loggingIn = true
        error = false
        
        Network.shared.apollo.perform(mutation: LoginMutation(username: username, password: password)) { result in
            self.loggingIn = false

            switch result {
            case .success(let result):
                guard let token = result.data?.login.token else {
                    self.error = true
                    return
                }
                
                self.error = false
                completion(token)
            case .failure:
                self.error = true
            }
        }
    }
}
