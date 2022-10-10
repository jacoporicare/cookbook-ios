//
//  LoginView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 06.04.2022.
//

import Apollo
import SwiftUI

struct LoginView: View {
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
        Form {
            TextField("Uživatel", text: $username)
            HStack {
                SecureField("Heslo", text: $password)

                if loggingIn {
                    ProgressView()
                }
            }
        }
        .navigationTitle("Přihlášení")
        .navigationBarTitleDisplayMode(.inline)
        .textInputAutocapitalization(.never)
        .disableAutocorrection(true)
        .disabled(loggingIn)
        .alert("Neplatný uživatel nebo heslo.", isPresented: $error) {}
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Přihlásit", action: login)
                    .disabled(loginDisabled)
            }

            ToolbarItem(placement: .cancellationAction) {
                Button("Zrušit") {
                    dismiss()
                }
            }
        }
    }

    func login() {
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
