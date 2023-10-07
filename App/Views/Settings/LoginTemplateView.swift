//
//  LoginScreenView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 06.04.2022.
//

import SwiftUI

@available(*, deprecated, message: "Not used, using web view (WebAuthenticationSession) instead.")
struct LoginTemplateView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var error: Bool
    @Binding var username: String
    @Binding var password: String

    let loggingIn: Bool
    let loginDisabled: Bool

    let onLogin: Callback

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
                Button("Přihlásit", action: onLogin)
                    .disabled(loginDisabled)
            }

            ToolbarItem(placement: .cancellationAction) {
                Button("Zrušit") {
                    dismiss()
                }
            }
        }
    }
}

@available(*, deprecated, message: "Not used, using web view (WebAuthenticationSession) instead.")
struct LoginTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                LoginTemplateView(
                    error: .constant(false),
                    username: .constant(""),
                    password: .constant(""),
                    loggingIn: false,
                    loginDisabled: true,
                    onLogin: {}
                )
            }
            .previewDisplayName("Init")

            NavigationStack {
                LoginTemplateView(
                    error: .constant(false),
                    username: .constant("user1"),
                    password: .constant("xxxxx"),
                    loggingIn: false,
                    loginDisabled: false,
                    onLogin: {}
                )
            }
            .previewDisplayName("Filled")

            NavigationStack {
                LoginTemplateView(
                    error: .constant(false),
                    username: .constant("user1"),
                    password: .constant("xxxxx"),
                    loggingIn: true,
                    loginDisabled: true,
                    onLogin: {}
                )
            }
            .previewDisplayName("Logging In")
        }
    }
}
