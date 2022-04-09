//
//  LoginViewModel.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 05.04.2022.
//

import Apollo
import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    private var request: Cancellable?
    
    @Published var loggingIn = false
    @Published var error = false
    @Published var username = ""
    @Published var password = ""
    
    var loginDisabled: Bool {
        username.isEmpty || password.isEmpty
    }
    
    func login(success: @escaping (String) -> Void) {
        loggingIn = true
        error = false
        
        request = Network.shared.apollo.perform(mutation: LoginMutation(username: username, password: password)) { [weak self] result in
            self?.loggingIn = false
            
            switch result {
            case .success(let result):
                guard let token = result.data?.login.token else { fallthrough }
                success(token)
            case .failure:
                self?.error = true
            }
        }
    }
    
    deinit {
        request?.cancel()
    }
}
