//
//  LoginScreen.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 06.04.2022.
//

import SwiftUI

/// The native login form. Reachable when `authMethod` in `SettingsScreen` is `.native`.
///
/// Sending a password straight to our own API is the one case where that is still
/// acceptable practice (first-party client, first-party backend); the trade-off
/// against the web flow is maintenance, not security - see `AuthMethod`.
struct LoginScreen: View {
    @Environment(CurrentUserStore.self) private var currentUserStore
    @Environment(\.dismiss) private var dismiss

    @State private var username = ""
    @State private var password = ""
    @State private var isLoggingIn = false
    @State private var errorMessage: String?

    private var isLoginDisabled: Bool {
        username.isEmpty || password.isEmpty || isLoggingIn
    }

    var body: some View {
        Form {
            TextField("Uživatel", text: $username)
                .textContentType(.username)

            HStack {
                SecureField("Heslo", text: $password)
                    .textContentType(.password)

                if isLoggingIn {
                    ProgressView()
                }
            }
        }
        .navigationTitle("Přihlášení")
        .navigationBarTitleDisplayMode(.inline)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .disabled(isLoggingIn)
        .alert(
            errorMessage ?? "Přihlášení se nezdařilo.",
            isPresented: Binding(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })
        ) {}
        .onSubmit(logIn)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Přihlásit", action: logIn)
                    .disabled(isLoginDisabled)
            }

            ToolbarItem(placement: .cancellationAction) {
                Button("Zrušit") {
                    dismiss()
                }
            }
        }
    }

    private func logIn() {
        guard !isLoginDisabled else { return }

        Task {
            isLoggingIn = true
            defer { isLoggingIn = false }

            do {
                try await currentUserStore.logIn(username: username, password: password)
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}

#if DEBUG
#Preview("Empty") {
    NavigationStack {
        LoginScreen()
    }
    .previewStores()
}

#Preview("Filled") {
    NavigationStack {
        LoginScreen()
    }
    .previewStores()
}
#endif
