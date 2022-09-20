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
    @StateObject private var model = Model()

    var body: some Scene {
        WindowGroup {
            // Remove AnyView in Xcode 14.1 (hopefully)
            AnyView(
                ContentView()
                    .environmentObject(model)
            )
        }
        .backgroundTask(.appRefresh("cz.jakubricar.Zradelnik.refresh")) {
            scheduleAppRefresh()

            do {
                _ = try await model.fetchRecipesAsync()
            } catch {
                NSLog(error.localizedDescription)
            }
        }
        .onChange(of: phase) { newPhase in
            switch newPhase {
            case .active:
                // In case of disabled background app refresh we want to get fresh data every 24h
                if let lastFetchDate = model.lastFetchDate, lastFetchDate < Date(timeIntervalSinceNow: -24 * 3600) {
                    model.fetchRecipes(silent: true)
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
