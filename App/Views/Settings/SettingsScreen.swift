//
//  SettingsScreen.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 07.04.2022.
//

import AuthenticationServices
import SwiftUI

/// Which login flow the app uses. Both are wired up and interchangeable - flip this
/// to compare the hosted web flow against the native form.
enum AuthMethod {
    /// `ASWebAuthenticationSession` against the web app. Password reset, MFA and any
    /// future auth method are inherited from the web without an app release, and the
    /// app never handles a password. Costs a system consent alert on first use.
    case web
    /// The native username/password form talking to the `login` mutation. No consent
    /// alert and full design control, but every auth capability has to be built twice.
    case native
}

private let authMethod: AuthMethod = .web

struct SettingsScreen: View {
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    @Environment(CurrentUserStore.self) private var currentUserStore

    @State private var isLoginSheetPresented = false

    var body: some View {
        Form {
            Section("Účet") {
                if currentUserStore.isLoggedIn {
                    switch currentUserStore.loadingStatus {
                    case .loading:
                        HStack(spacing: 4) {
                            Text("Načítání...")
                                .foregroundColor(.secondary)
                            ProgressView()
                        }
                    case .error(let error):
                        Text(error)
                    case .data:
                        Text(currentUserStore.userDisplayName ?? "Chyba")
                    }

                    Button("Odhlásit") {
                        currentUserStore.logOut()
                    }
                } else {
                    Button("Přihlásit", action: logIn)
                }
            }
        }
        .navigationTitle("Nastavení")
        .task {
            await currentUserStore.loadCurrentUserIfNeeded()
        }
        .sheet(isPresented: $isLoginSheetPresented) {
            NavigationStack {
                LoginScreen()
            }
        }
    }

    private func logIn() {
        switch authMethod {
        case .web:
            logInWithWebSession()
        case .native:
            isLoginSheetPresented = true
        }
    }

    private func logInWithWebSession() {
        Task {
            do {
                let urlWithToken = try await webAuthenticationSession.authenticate(
                    using: URL(string: "https://www.zradelnik.cz/prihlaseni?redirect_uri=zradelnik://auth")!,
                    callbackURLScheme: "zradelnik"
                )

                guard let items = URLComponents(url: urlWithToken, resolvingAgainstBaseURL: false)?.queryItems,
                      let token = items.first(where: { $0.name == "access_token" })?.value
                else {
                    return
                }

                await currentUserStore.signIn(withAccessToken: token)
            } catch {
                // The user cancelling the browser sheet lands here too, so there is
                // nothing worth surfacing.
            }
        }
    }
}

#if DEBUG
#Preview("Logged out") {
    NavigationStack {
        SettingsScreen()
    }
    .previewStores()
}

#Preview("Logged in") {
    NavigationStack {
        SettingsScreen()
    }
    .previewStores(isLoggedIn: true)
}
#endif
