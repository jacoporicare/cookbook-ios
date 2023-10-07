//
//  SettingsTemplateView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 07.04.2022.
//

import SwiftUI

struct SettingsTemplateView: View {
    let isUserLoggedIn: Bool
    let userLoadingStatus: LoadingStatus
    let userDisplayName: String?

    let onLogin: Callback
    let onLogout: Callback

    var body: some View {
        Form {
            Section("Účet") {
                if isUserLoggedIn {
                    switch userLoadingStatus {
                    case .loading:
                        HStack(spacing: 4) {
                            Text("Načítání...")
                                .foregroundColor(.secondary)
                            ProgressView()
                        }
                    case .error(let error):
                        Text(error)
                    case .data:
                        Text(userDisplayName ?? "Chyba")
                    }

                    Button("Odhlásit", action: onLogout)
                } else {
                    Button("Přihlásit", action: onLogin)
                }
            }
        }
        .navigationTitle("Nastavení")
    }
}

struct SettingsTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                SettingsTemplateView(
                    isUserLoggedIn: false,
                    userLoadingStatus: .data,
                    userDisplayName: nil,
                    onLogin: {},
                    onLogout: {}
                )
            }
            .previewDisplayName("Logged out")
            
            NavigationStack {
                SettingsTemplateView(
                    isUserLoggedIn: true,
                    userLoadingStatus: .data,
                    userDisplayName: "User name",
                    onLogin: {},
                    onLogout: {}
                )
            }
            .previewDisplayName("Logged in")
            
            NavigationStack {
                SettingsTemplateView(
                    isUserLoggedIn: true,
                    userLoadingStatus: .loading,
                    userDisplayName: nil,
                    onLogin: {},
                    onLogout: {}
                )
            }
            .previewDisplayName("Loading")
        }
    }
}
