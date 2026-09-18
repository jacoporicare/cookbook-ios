//
//  ZradelnikApp.swift
//  Zradelnik
//
//  Created by Jakub Řicař on 29.03.2022.
//

import BackgroundTasks
import SwiftUI

let zradelnikLocale = Locale(identifier: "cs")

private let refreshTaskIdentifier = "cz.jakubricar.Zradelnik.refresh"

@main
struct ZradelnikApp: App {
    @Environment(\.scenePhase) private var phase

    @State private var routing = Routing()
    @State private var recipeStore: RecipeStore
    @State private var currentUserStore: CurrentUserStore

    private let services: AppServices

    @State private var tabSelectionValue: AppTab = .recipes
    @State private var previousTab: AppTab = .recipes
    @State private var tabPendingPopToRoot: AppTab?
    @State private var searchText = ""
    @State private var isSearchActive = false

    init() {
        let services = AppServices.live()

        self.services = services
        _recipeStore = State(initialValue: RecipeStore(service: services.recipes))
        _currentUserStore = State(initialValue: CurrentUserStore(service: services.auth))
    }

    // Re-selecting the already selected tab is the only tab event SwiftUI doesn't
    // report through onChange, so it needs a custom setter. Scrolling the list back
    // to the top on re-selection is handled by the system since iOS 18; everything
    // else that reacts to an actual change lives in onChange below.
    private var tabSelection: Binding<AppTab> {
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
            @Bindable var routing = routing

            TabView(selection: tabSelection) {
                Tab("Recepty", systemImage: "menucard", value: AppTab.recipes) {
                    NavigationStack(path: $routing.recipeListPath) {
                        RecipeListScreen()
                    }
                }

                Tab("Sous-vide", systemImage: "thermometer", value: AppTab.sousVideRecipes) {
                    NavigationStack(path: $routing.sousVidePath) {
                        RecipeListScreen(isSousVideView: true)
                    }
                }

                Tab("Nastavení", systemImage: "gear", value: AppTab.settings) {
                    NavigationStack {
                        SettingsScreen()
                    }
                }

                Tab(value: AppTab.search, role: .search) {
                    NavigationStack(path: $routing.searchPath) {
                        SearchScreen(searchText: $searchText, isSearchActive: $isSearchActive) {
                            searchText = ""
                            tabSelectionValue = previousTab
                        }
                    }
                }
            }
            .tabViewStyle(.sidebarAdaptable)
            .environment(routing)
            .environment(recipeStore)
            .environment(currentUserStore)
            .environment(\.imageUploader, services.imageUploader)
        }
        .backgroundTask(.appRefresh(refreshTaskIdentifier)) {
            scheduleAppRefresh()

            await recipeStore.refresh()
        }
        .onChange(of: phase) { _, newPhase in
            switch newPhase {
            case .active:
                // In case of disabled background app refresh we want to get fresh data every 24h
                if let lastFetchDate = recipeStore.lastFetchDate, lastFetchDate < Date(timeIntervalSinceNow: -24 * 3600) {
                    recipeStore.reload(silent: true)
                }

                BGTaskScheduler.shared.getPendingTaskRequests { requests in
                    if !requests.contains(where: { $0.identifier == refreshTaskIdentifier }) {
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

private func scheduleAppRefresh() {
    let request = BGAppRefreshTaskRequest(identifier: refreshTaskIdentifier)
    request.earliestBeginDate = Date(timeIntervalSinceNow: 24 * 3600)

    try? BGTaskScheduler.shared.submit(request)
}
