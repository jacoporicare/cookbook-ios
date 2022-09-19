//
//  ZradelnikApp.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import SwiftUI

@main
struct ZradelnikApp: App {
    @Environment(\.scenePhase) private var phase
    @StateObject private var model = Model()

    var body: some Scene {
        WindowGroup {
            // Remove AnyView in Xcode 14.1 (hopefully)
            AnyView(
                ContentView()
                    .environmentObject(model)
            )
        }
        .onChange(of: phase) { newPhase in
            switch newPhase {
            case .active:
                if let lastFetchDate = model.lastFetchDate, lastFetchDate < Date(timeIntervalSinceNow: -24 * 3600) {
                    model.refetchRecipes()
                }
            default:
                break
            }
        }
    }
}
