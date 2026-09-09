//
//  ZradelnikApp.swift
//  Zradelnik
//
//  Created by Jakub Řicař on 29.03.2022.
//

import BackgroundTasks
import SwiftUI

enum AppTab {
    case recipes
    case sousVideRecipes
    case settings
    case search
}

@main
struct ZradelnikApp: App {
    @Environment(\.scenePhase) private var phase
    @StateObject private var routing = Routing()
    @StateObject private var recipeStore = RecipeStore()
    @StateObject private var currentUserStore = CurrentUserStore()

    @State private var tabSelectionValue: AppTab = .recipes
    @State private var previousTab: AppTab = .recipes
    @State private var tabPendingPopToRoot: AppTab?
    @State private var searchText = ""
    @State private var isSearchActive = false

    // Re-selecting the already selected tab is the only tab event SwiftUI doesn't
    // report through onChange, so it needs a custom setter. Scrolling the list back
    // to the top on re-selection is handled by the system since iOS 18; everything
    // else that reacts to an actual change lives in onChange below.
    var tabSelection: Binding<AppTab> {
        Binding(
            get: { tabSelectionValue },
            set: { newTab in
                if newTab == tabSelectionValue {
                    tabPendingPopToRoot = newTab
                }

                tabSelectionValue = newTab
            }
        )
    }

    var body: some Scene {
        WindowGroup {
            TabView(selection: tabSelection) {
                Tab("Recepty", systemImage: "menucard", value: AppTab.recipes) {
                    NavigationStack(path: $routing.recipeListStack) {
                        RecipesScreenView()
                    }
                }

                Tab("Sous-vide", systemImage: "thermometer", value: AppTab.sousVideRecipes) {
                    NavigationStack(path: $routing.sousVideListStack) {
                        RecipesScreenView(isSousVideView: true)
                    }
                }

                Tab("Nastavení", systemImage: "gear", value: AppTab.settings) {
                    NavigationStack {
                        SettingsScreenView()
                    }
                }

                Tab(value: AppTab.search, role: .search) {
                    SearchResultsView(searchText: $searchText, isSearchActive: $isSearchActive) {
                        searchText = ""
                        tabSelectionValue = previousTab
                    }
                }
            }
            .tabViewStyle(.sidebarAdaptable)
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
        .onChange(of: phase) { oldPhase, newPhase in
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
        .onChange(of: tabSelectionValue) { oldTab, newTab in
            if oldTab != .search {
                previousTab = oldTab
            }

            if newTab == .search {
                isSearchActive = true
            }
        }
        .onChange(of: tabPendingPopToRoot) { _, newValue in
            guard let tab = newValue else { return }
            routing.popToRoot(tab)
            tabPendingPopToRoot = nil
        }
    }
}

func scheduleAppRefresh() {
    let request = BGAppRefreshTaskRequest(identifier: "cz.jakubricar.Zradelnik.refresh")
    request.earliestBeginDate = Date(timeIntervalSinceNow: 24 * 3600)

    try? BGTaskScheduler.shared.submit(request)
}

let zradelnikLocale = Locale(identifier: "cs")
