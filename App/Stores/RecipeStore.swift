//
//  RecipeStore.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 15.04.2022.
//

import Foundation
import Observation

@MainActor
@Observable
final class RecipeStore {
    private(set) var loadingStatus: LoadingStatus = .loading
    private(set) var recipes: [Recipe] = []

    var sousVideRecipes: [Recipe] {
        recipes.filter(\.isForSousVide)
    }

    private let service: any RecipeService
    // `nonisolated(unsafe)` so `deinit`, which is never main-actor isolated, can
    // cancel it. Only ever written from the main actor, and `deinit` runs when no
    // other reference is left.
    @ObservationIgnored private nonisolated(unsafe) var watchTask: Task<Void, Never>?

    init(service: any RecipeService) {
        self.service = service
    }

    /// The store outlives every view, so the watch task is never torn down in
    /// practice; cancelling it would also cancel the underlying Apollo watcher.
    deinit {
        watchTask?.cancel()
    }

    func recipe(id: String) -> Recipe? {
        recipes.first { $0.id == id }
    }

    // MARK: - Loading

    func startWatching() {
        guard watchTask == nil else { return }

        watchTask = Task { [weak self, service] in
            for await result in service.recipeUpdates() {
                guard let self else { return }

                switch result {
                case .success(let recipes):
                    self.recipes = recipes
                    self.loadingStatus = .data
                    self.lastFetchDate = Date()

                case .failure(let error):
                    self.loadingStatus = .error(error.localizedDescription)
                }
            }
        }
    }

    /// Fire-and-forget refresh, for the toolbar button and the foreground staleness check.
    func reload(silent: Bool = false) {
        Task { await refresh(silent: silent) }
    }

    /// Awaitable refresh, for pull-to-refresh and the background refresh task.
    ///
    /// Errors are recorded in `loadingStatus` rather than thrown, because every caller
    /// wants the same handling.
    func refresh(silent: Bool = true) async {
        if !silent {
            loadingStatus = .loading
        }

        do {
            try await service.refreshRecipes()

            // A network fetch that returns unchanged data does not write anything new to
            // the cache, so the watcher stays silent. That means success has to be
            // recorded here - waiting for the watcher would leave the UI on the spinner
            // forever whenever nothing had changed.
            loadingStatus = .data
            lastFetchDate = Date()
        } catch {
            // A failed refresh should not throw away a list we can still show.
            loadingStatus = recipes.isEmpty ? .error(error.localizedDescription) : .data
        }
    }

    // MARK: - Mutations

    // Apollo normalizes mutation results into the same cache the watcher reads, so
    // anything that returns a RecipeDetails updates the list without a refetch.
    // Creating and deleting change which recipes exist, which the watcher cannot
    // infer, so those refresh explicitly.

    func markCooked(recipeId: String, date: Date) async throws {
        _ = try await service.markCooked(recipeId: recipeId, date: date)
    }

    func deleteCooked(recipeId: String, cookedId: String) async throws {
        _ = try await service.deleteCooked(recipeId: recipeId, cookedId: cookedId)
    }

    func create(_ draft: RecipeDraft, imageId: String?) async throws -> Recipe {
        let recipe = try await service.createRecipe(draft, imageId: imageId)
        try? await service.refreshRecipes()
        return recipe
    }

    func update(id: String, draft: RecipeDraft, imageId: String?) async throws -> Recipe {
        try await service.updateRecipe(id: id, draft: draft, imageId: imageId)
    }

    func delete(id: String) async throws {
        try await service.deleteRecipe(id: id)
        try? await service.refreshRecipes()
    }

    // MARK: - Last fetch

    /// Drives the "refresh if the data is a day old" check on foreground. Not
    /// observed by any view, so plain UserDefaults is enough.
    var lastFetchDate: Date? {
        get { UserDefaults.standard.object(forKey: "lastFetchDate") as? Date }
        set { UserDefaults.standard.set(newValue, forKey: "lastFetchDate") }
    }
}
