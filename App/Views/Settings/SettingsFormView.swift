//
//  SettingsFormView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 07.04.2022.
//

import SwiftUI

struct SettingsFormView: View {
    @EnvironmentObject private var currentUserStore: CurrentUserStore
    @State private var showingLoginSheet = false

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
                        currentUserStore.resetAccessToken()
                    }
                } else {
                    Button("Přihlásit") {
                        showingLoginSheet = true
                    }
                }
            }
        }
        .onAppear {
            if currentUserStore.isLoggedIn && currentUserStore.userDisplayName == nil {
                currentUserStore.load()
            }
        }
        .sheet(isPresented: $showingLoginSheet) {
            NavigationStack {
                LoginView()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsFormView()
            .environmentObject(CurrentUserStore())
    }
}
