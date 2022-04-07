//
//  SettingsView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 07.04.2022.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authentication: Authentication
    
    var body: some View {
        Form {
            Section("Účet") {
                if authentication.isLoggedIn {
                    Text(authentication.userDisplayName ?? "Chyba")
                    Button("Odhlásit") {
                        authentication.updateAccessToken(accessToken: nil)
                    }
                } else {
                    NavigationLink("Přihlásit") {
                        LoginView()
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
