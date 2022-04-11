//
//  SettingsHost.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 07.04.2022.
//

import SwiftUI

struct SettingsHost: View {
    @State private var showingLogin = false

    var body: some View {
        SettingsView()
            .navigationTitle("Nastavení")
    }
}

struct SettingsHost_Previews: PreviewProvider {
    static var previews: some View {
        SettingsHost()
            .environmentObject(Authentication())
    }
}
