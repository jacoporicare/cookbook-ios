//
//  SettingsScreenView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 07.04.2022.
//

import SwiftUI
import AuthenticationServices

struct SettingsScreenView: View {
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    @EnvironmentObject private var currentUserStore: CurrentUserStore

    var body: some View {
        SettingsTemplateView(
            isUserLoggedIn: currentUserStore.isLoggedIn,
            userLoadingStatus: currentUserStore.loadingStatus,
            userDisplayName: currentUserStore.userDisplayName,
            onLogin: handleLogin,
            onLogout: { currentUserStore.resetAccessToken() }
        )
        .onAppear {
            if currentUserStore.isLoggedIn && currentUserStore.userDisplayName == nil {
                currentUserStore.load()
            }
        }
    }
    
    func handleLogin() {
        Task {
            do {
                let urlWithToken = try await webAuthenticationSession.authenticate(
                    using: URL(string: "https://www.zradelnik.eu/prihlaseni?redirect_uri=zradelnik://auth")!,
                    callbackURLScheme: "zradelnik"
                )
                
                guard let items = URLComponents(url: urlWithToken, resolvingAgainstBaseURL: false)?.queryItems,
                      let token = items.first(where: { $0.name == "access_token" })?.value
                else {
                    return
                }
                
                currentUserStore.setAccessToken(accessToken: token)
            } catch {}
        }
    }
}
