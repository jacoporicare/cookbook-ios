//
//  SettingsView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 07.04.2022.
//

import SwiftUI

struct SettingsView: View {
    @State private var showingLogin = false

    var body: some View {
        SettingsFormView()
            .navigationTitle("Nastavení")
    }
}

struct SettingsHost_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(Model())
    }
}
