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
    enum Tab {
        case recipes
        case instantPotRecipes
        case settings
    }

    @Environment(\.scenePhase) private var phase
    @StateObject private var routing = Routing()
    @StateObject private var recipeStore = RecipeStore()
    @StateObject private var currentUserStore = CurrentUserStore()

    @State private var tabSelectionValue: Tab = .recipes
    @State private var resetRecipeListStack = false

    var tabSelection: Binding<Tab> {
        Binding(
            get: { self.tabSelectionValue },
            set: {
                if $0 == .recipes || $0 == .instantPotRecipes,
                   self.tabSelectionValue == .recipes || self.tabSelectionValue == .instantPotRecipes
                {
                    resetRecipeListStack = true
                }

                self.tabSelectionValue = $0
            }
        )
    }

    var body: some Scene {
        WindowGroup {
            TabView(selection: tabSelection) {
                NavigationStack(path: $routing.recipeListStack) {
                    RecipesView()
                }
                .tabItem {
                    Label("Recepty", systemImage: "fork.knife")
                }
                .tag(Tab.recipes)

                NavigationStack(path: $routing.recipeListStack) {
                    RecipesView(isInstantPotView: true)
                }
                .tabItem {
                    Label("Instant Pot", image: "Multicooker")
                }
                .tag(Tab.instantPotRecipes)

                NavigationStack {
                    SettingsView()
                }
                .tabItem {
                    Label("Nastavení", systemImage: "gear")
                }
                .tag(Tab.settings)
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
        .onChange(of: resetRecipeListStack) { newValue in
            guard newValue else { return }
            routing.recipeListStack = []
            resetRecipeListStack = false
        }
    }
}

func scheduleAppRefresh() {
    let request = BGAppRefreshTaskRequest(identifier: "cz.jakubricar.Zradelnik.refresh")
    request.earliestBeginDate = Date(timeIntervalSinceNow: 24 * 3600)

    try? BGTaskScheduler.shared.submit(request)
}

let zradelnikLocale = Locale(identifier: "cs")
