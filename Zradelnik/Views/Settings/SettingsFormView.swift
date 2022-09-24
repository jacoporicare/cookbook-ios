//
//  SettingsFormView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 07.04.2022.
//

import SwiftUI

struct SettingsFormView: View {
    @EnvironmentObject private var model: Model
    @State private var showingLoginSheet = false

    var body: some View {
        Form {
            Section("Účet") {
                if model.isLoggedIn {
                    Text(model.userDisplayName ?? "Chyba")
                    Button("Odhlásit") {
                        model.resetAccessToken()
                    }
                } else {
                    Button("Přihlásit") {
                        showingLoginSheet = true
                    }
                }
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
            .environmentObject(Model())
    }
}
