//
//  RecipeService.swift
//  Zradelnik
//

import API
import Apollo
import Foundation

enum RecipeServiceError: LocalizedError {
    case noData(String?)

    var errorDescription: String? {
        switch self {
        case .noData(let message):
            message ?? "Server nevrátil žádná data."
        }
    }
}

/// Everything the app does with recipes over the network. `RecipeStore` talks to
/// this instead of reaching for a shared Apollo client, so it can be driven by a
/// stub in previews and tests.
protocol RecipeService {
    /// A stream of the recipe list that re-emits whenever the normalized cache changes.
    /// Cancelling the consuming task tears the underlying watcher down.
    func recipeUpdates() -> AsyncStream<Result<[Recipe], Error>>

    /// Fetches from the network and writes through to the cache, which makes
    /// `recipeUpdates()` emit. Nothing is returned on purpose: the stream is the
    /// single path recipes reach the store by.
    func refreshRecipes() async throws

    func markCooked(recipeId: String, date: Date) async throws -> Recipe
    func deleteCooked(recipeId: String, cookedId: String) async throws -> Recipe
    func createRecipe(_ draft: RecipeDraft, imageId: String?) async throws -> Recipe
    func updateRecipe(id: String, draft: RecipeDraft, imageId: String?) async throws -> Recipe
    func deleteRecipe(id: String) async throws
}

final class ApolloRecipeService: RecipeService {
    private let client: ApolloClient

    init(client: ApolloClient) {
        self.client = client
    }

    // Cooked dates are day-granular; the server stores them as UTC midnight.
    private static let utcCalendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .gmt
        return calendar
    }()

    func recipeUpdates() -> AsyncStream<Result<[Recipe], Error>> {
        AsyncStream { continuation in
            // `watch` is async in Apollo 2, so the watcher is created in a task and
            // parked in a box that teardown can reach.
            let box = WatcherBox()

            Task {
                let watcher = await client.watch(
                    query: RecipesQuery(),
                    cachePolicy: CachePolicy.Query.CacheAndNetwork.cacheAndNetwork
                ) { result in
                    switch result {
                    case .success(let response):
                        guard let data = response.data else {
                            continuation.yield(.failure(RecipeServiceError.noData(response.errors?.first?.message)))
                            return
                        }

                        continuation.yield(.success(data.recipes.map { Recipe(from: $0.fragments.recipeDetails) }))
                    case .failure(let error):
                        continuation.yield(.failure(error))
                    }
                }

                await box.store(watcher)
            }

            continuation.onTermination = { _ in
                Task { await box.cancel() }
            }
        }
    }

    func refreshRecipes() async throws {
        _ = try await client.fetch(query: RecipesQuery(), cachePolicy: .networkOnly)
    }

    func markCooked(recipeId: String, date: Date) async throws -> Recipe {
        let utcMidnight = Self.utcCalendar.startOfDay(for: date)
        let response = try await client.perform(mutation: RecipeCookedMutation(id: recipeId, date: utcMidnight))

        return try Self.unwrap(response) { Recipe(from: $0.recipeCooked.fragments.recipeDetails) }
    }

    func deleteCooked(recipeId: String, cookedId: String) async throws -> Recipe {
        let response = try await client.perform(
            mutation: DeleteRecipeCookedMutation(recipeId: recipeId, cookedId: cookedId)
        )

        return try Self.unwrap(response) { Recipe(from: $0.deleteRecipeCooked.fragments.recipeDetails) }
    }

    func createRecipe(_ draft: RecipeDraft, imageId: String?) async throws -> Recipe {
        let response = try await client.perform(
            mutation: CreateRecipeMutation(recipe: draft.toRecipeInput(), imageId: imageId.map { .some($0) } ?? nil)
        )

        return try Self.unwrap(response) { Recipe(from: $0.createRecipe.fragments.recipeDetails) }
    }

    func updateRecipe(id: String, draft: RecipeDraft, imageId: String?) async throws -> Recipe {
        let response = try await client.perform(
            mutation: UpdateRecipeMutation(
                id: id,
                recipe: draft.toRecipeInput(),
                imageId: imageId.map { .some($0) } ?? nil
            )
        )

        return try Self.unwrap(response) { Recipe(from: $0.updateRecipe.fragments.recipeDetails) }
    }

    func deleteRecipe(id: String) async throws {
        let response = try await client.perform(mutation: DeleteRecipeMutation(id: id))

        _ = try Self.unwrap(response) { $0.deleteRecipe }
    }

    private static func unwrap<Operation: GraphQLOperation, Value>(
        _ response: GraphQLResponse<Operation>,
        transform: (Operation.Data) -> Value?
    ) throws -> Value {
        guard let data = response.data, let value = transform(data) else {
            throw RecipeServiceError.noData(response.errors?.first?.message)
        }

        return value
    }
}

/// Holds the watcher created asynchronously by `recipeUpdates()` so that tearing the
/// stream down cancels it, even if teardown wins the race against creation.
private actor WatcherBox {
    private var watcher: GraphQLQueryWatcher<RecipesQuery>?
    private var isCancelled = false

    func store(_ watcher: GraphQLQueryWatcher<RecipesQuery>) {
        if isCancelled {
            watcher.cancel()
            return
        }

        self.watcher = watcher
    }

    func cancel() {
        isCancelled = true
        watcher?.cancel()
        watcher = nil
    }
}
