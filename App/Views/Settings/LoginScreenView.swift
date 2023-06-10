//
//  LoginScreenView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 06.04.2022.
//

import Apollo
import SwiftUI

struct LoginScreenView: View {
    @EnvironmentObject private var currentUserStore: CurrentUserStore
    @Environment(\.dismiss) private var dismiss

    @State private var loggingIn = false
    @State private var error = false
    @State private var username = ""
    @State private var password = ""

    private var loginDisabled: Bool {
        username.isEmpty || password.isEmpty || loggingIn
    }

    var body: some View {
        LoginTemplateView(
            error: $error,
            username: $username,
            password: $password,
            loggingIn: loggingIn,
            loginDisabled: loginDisabled,
            onLogin: handleLogin
        )
    }

    func handleLogin() {
        loggingIn = true
        error = false

        Network.shared.apollo.perform(mutation: LoginMutation(username: username, password: password)) { result in
            self.loggingIn = false

            switch result {
            case .success(let result):
                guard let token = result.data?.login.token else { fallthrough }
                currentUserStore.setAccessToken(accessToken: token)
                dismiss()
            case .failure:
                self.error = true
            }
        }
    }
}
