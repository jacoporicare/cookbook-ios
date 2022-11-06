//
//  ZradelnikApp.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import BackgroundTasks
import SwiftUI

@main
struct ZradelnikApp: App {
    @Environment(\.scenePhase) private var phase
    @StateObject private var routing = Routing()
    @StateObject private var recipeStore = RecipeStore()
    @StateObject private var currentUserStore = CurrentUserStore()

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack(path: $routing.recipeListStack) {
                    RecipesView()
                }
                .tabItem {
                    Label("Recepty", systemImage: "fork.knife")
                }

                NavigationStack {
                    SettingsView()
                }
                .tabItem {
                    Label("Nastavení", systemImage: "gear")
                }
            }
            .environmentObject(routing)
            .environmentObject(recipeStore)
            .environmentObject(currentUserStore)
        }
        .backgroundTask(.appRefresh("cz.jakubricar.Zradelnik.refresh")) {
            scheduleAppRefresh()

            do {
                try await recipeStore.loadAsync()
            } catch {
                NSLog(error.localizedDescription)
            }
        }
        .onChange(of: phase) { newPhase in
            switch newPhase {
            case .active:
                // In case of disabled background app refresh we want to get fresh data every 24h
                if let lastFetchDate = recipeStore.lastFetchDate, lastFetchDate < Date(timeIntervalSinceNow: -24 * 3600) {
                    recipeStore.reload(silent: true)
                }

                BGTaskScheduler.shared.getPendingTaskRequests { requests in
                    if !requests.contains(where: { $0.identifier == "cz.jakubricar.Zradelnik.refresh" }) {
                        scheduleAppRefresh()
                    }
                }
            default:
                break
            }
        }
    }
}

func scheduleAppRefresh() {
    let request = BGAppRefreshTaskRequest(identifier: "cz.jakubricar.Zradelnik.refresh")
    request.earliestBeginDate = Date(timeIntervalSinceNow: 24 * 3600)

    try? BGTaskScheduler.shared.submit(request)
}

let zradelnikLocale = Locale(identifier: "cs")
