//
//  SettingsScreenView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 07.04.2022.
//

import SwiftUI

struct SettingsScreenView: View {
    @EnvironmentObject private var currentUserStore: CurrentUserStore

    @State private var showingLogin = false

    var body: some View {
        SettingsTemplateView(
            isUserLoggedIn: currentUserStore.isLoggedIn,
            userLoadingStatus: currentUserStore.loadingStatus,
            userDisplayName: currentUserStore.userDisplayName,
            onLogout: { currentUserStore.resetAccessToken() }
        )
        .onAppear {
            if currentUserStore.isLoggedIn && currentUserStore.userDisplayName == nil {
                currentUserStore.load()
            }
        }
    }
}
