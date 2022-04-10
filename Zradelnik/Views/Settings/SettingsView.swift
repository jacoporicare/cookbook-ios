//
//  SettingsView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 07.04.2022.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var authentication: Authentication
    @State private var showingLoginSheet = false

    var body: some View {
        Form {
            Section("Účet") {
                if authentication.isLoggedIn {
                    Text(authentication.userDisplayName ?? "Chyba")
                    Button("Odhlásit") {
                        authentication.updateAccessToken(accessToken: nil)
                    }
                } else {
                    Button("Přihlásit") {
                        showingLoginSheet = true
                    }
                }
            }
        }
        .sheet(isPresented: $showingLoginSheet) {
            NavigationView {
                LoginView()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
