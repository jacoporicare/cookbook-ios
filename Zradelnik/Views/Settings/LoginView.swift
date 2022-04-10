//
//  LoginView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 06.04.2022.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var authentication: Authentication
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        Form {
            TextField("Uživatel", text: $viewModel.username)
            HStack {
                SecureField("Heslo", text: $viewModel.password)

                if viewModel.loggingIn {
                    ProgressView()
                }
            }
        }
        .navigationTitle("Přihlášení")
        .navigationBarTitleDisplayMode(.inline)
        .textInputAutocapitalization(.never)
        .disableAutocorrection(true)
        .disabled(viewModel.loggingIn)
        .alert("Neplatný uživatel nebo heslo.", isPresented: $viewModel.error) {}
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Přihlásit") {
                    viewModel.login { accessToken in
                        authentication.updateAccessToken(accessToken: accessToken)
                        dismiss()
                    }
                }
                .disabled(viewModel.loginDisabled)
            }

            ToolbarItem(placement: .cancellationAction) {
                Button("Zrušit") {
                    dismiss()
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
