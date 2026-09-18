//
//  CurrentUserStore.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 26.09.2022.
//

import Foundation
import Observation

@MainActor
@Observable
final class CurrentUserStore {
    private(set) var loadingStatus: LoadingStatus = .loading
    private(set) var userDisplayName: String?

    /// Stored rather than read from the Keychain on demand, so SwiftUI actually
    /// observes it. `UnauthenticatedInterceptor` can clear the token behind our
    /// back, which is what the notification below is for.
    private(set) var isLoggedIn: Bool

    private let service: any AuthService
    // See the note on RecipeStore.watchTask.
    @ObservationIgnored private nonisolated(unsafe) var unauthenticatedTask: Task<Void, Never>?

    init(service: any AuthService) {
        self.service = service
        self.isLoggedIn = service.accessToken != nil

        unauthenticatedTask = Task { [weak self] in
            let notifications = NotificationCenter.default.notifications(named: .zradelnikUnauthenticated)

            for await _ in notifications {
                guard let self else { return }
                self.handleTokenRejected()
            }
        }
    }

    deinit {
        unauthenticatedTask?.cancel()
    }

    // MARK: - Session

    /// Used by the web flow, which brings its own token back from the browser.
    func signIn(withAccessToken token: String) async {
        service.storeAccessToken(token)
        isLoggedIn = true
        await loadCurrentUser()
    }

    /// Used by the native login form.
    func logIn(username: String, password: String) async throws {
        let token = try await service.logIn(username: username, password: password)
        await signIn(withAccessToken: token)
    }

    func logOut() {
        service.clearAccessToken()
        isLoggedIn = false
        userDisplayName = nil
        loadingStatus = .loading
    }

    func loadCurrentUserIfNeeded() async {
        guard isLoggedIn, userDisplayName == nil else { return }
        await loadCurrentUser()
    }

    func loadCurrentUser() async {
        loadingStatus = .loading

        do {
            userDisplayName = try await service.loadDisplayName()
            loadingStatus = .data
        } catch {
            loadingStatus = .error(error.localizedDescription)
        }
    }

    private func handleTokenRejected() {
        guard isLoggedIn else { return }

        isLoggedIn = false
        userDisplayName = nil
        loadingStatus = .loading
    }
}
