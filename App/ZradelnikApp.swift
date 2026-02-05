//
//  ZradelnikApp.swift
//  Zradelnik
//
//  Created by Jakub Řicař on 29.03.2022.
//

import BackgroundTasks
import SwiftUI

@main
struct ZradelnikApp: App {
    enum AppTab {
        case recipes
        case sousVideRecipes
        case settings
        case search
    }

    @Environment(\.scenePhase) private var phase
    @StateObject private var routing = Routing()
    @StateObject private var recipeStore = RecipeStore()
    @StateObject private var currentUserStore = CurrentUserStore()

    @State private var tabSelectionValue: AppTab = .recipes
    @State private var previousTab: AppTab = .recipes
    @State private var shouldResetRecipeListStack = false
    @State private var shouldResetScrollPosition = false
    @State private var searchText = ""
    @State private var isSearchActive = false

    var tabSelection: Binding<AppTab> {
        Binding(
            get: { self.tabSelectionValue },
            set: {
                if routing.recipeListStack.isEmpty,
                   ($0 == .recipes && self.tabSelectionValue == .recipes) ||
                   ($0 == .sousVideRecipes && self.tabSelectionValue == .sousVideRecipes)
                {
                    shouldResetScrollPosition = true
                } else if $0 == .recipes || $0 == .sousVideRecipes,
                          self.tabSelectionValue == .recipes || self.tabSelectionValue == .sousVideRecipes
                {
                    shouldResetRecipeListStack = true
                }

                if self.tabSelectionValue != .search {
                    previousTab = self.tabSelectionValue
                }

                if $0 == .search && self.tabSelectionValue != .search {
                    isSearchActive = true
                }

                self.tabSelectionValue = $0
            }
        )
    }

    var body: some Scene {
        WindowGroup {
            TabView(selection: tabSelection) {
                Tab("Recepty", systemImage: "menucard", value: AppTab.recipes) {
                    NavigationStack(path: $routing.recipeListStack) {
                        RecipesScreenView(shouldResetScrollPosition: $shouldResetScrollPosition)
                    }
                }

                Tab("Sous-vide", systemImage: "thermometer", value: AppTab.sousVideRecipes) {
                    NavigationStack(path: $routing.recipeListStack) {
                        RecipesScreenView(isSousVideView: true, shouldResetScrollPosition: $shouldResetScrollPosition)
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
        .onChange(of: shouldResetRecipeListStack) { oldValue, newValue in
            guard newValue else { return }
            routing.recipeListStack = []
            shouldResetRecipeListStack = false
        }
    }
}

func scheduleAppRefresh() {
    let request = BGAppRefreshTaskRequest(identifier: "cz.jakubricar.Zradelnik.refresh")
    request.earliestBeginDate = Date(timeIntervalSinceNow: 24 * 3600)

    try? BGTaskScheduler.shared.submit(request)
}

let zradelnikLocale = Locale(identifier: "cs")
