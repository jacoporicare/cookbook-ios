//
//  PreviewData.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

#if DEBUG

import SwiftUI

// MARK: - Sample data

// Built as plain domain values rather than decoded Apollo payloads, so previews do
// not depend on the generated API types at all.

let previewRecipes: [Recipe] = [
    Recipe(
        id: "63506df6f463890829ae047b",
        title: "Hovězí steak sous-vide",
        imageUrl: nil,
        directions: """
        Maso osolte a opepřete, vložte do sáčku a **vakuujte**.

        1. Nastavte lázeň na 54 °C
        2. Vařte 2 hodiny
        3. Zprudka opečte na pánvi
        """,
        sideDish: "hranolky",
        preparationTime: "2 h 15 min",
        preparationTimeRaw: 135,
        servingCount: "2",
        servingCountRaw: 2,
        tags: [Recipe.sousVideTag],
        ingredients: [
            .init(id: "i1", name: "Maso", isGroup: true, amount: nil, amountRaw: nil, amountUnit: nil),
            .init(id: "i2", name: "hovězí roštěná", isGroup: false, amount: "400", amountRaw: 400, amountUnit: "g"),
            .init(id: "i3", name: "máslo", isGroup: false, amount: "2", amountRaw: 2, amountUnit: "lžíce"),
            .init(id: "i4", name: "sůl", isGroup: false, amount: nil, amountRaw: nil, amountUnit: nil),
        ],
        cookedHistory: [
            .init(id: "c1", date: Date(timeIntervalSinceNow: -60 * 60 * 24 * 30), user: .init(id: "u1", displayName: "Jakub")),
            .init(id: "c2", date: Date(timeIntervalSinceNow: -60 * 60 * 24 * 3), user: .init(id: "u1", displayName: "Jakub")),
        ]
    ),
    Recipe(
        id: "63506df6f463890829ae047c",
        title: "Čočková polévka",
        imageUrl: nil,
        directions: "Čočku propláchněte a vařte doměkka.",
        sideDish: nil,
        preparationTime: "45 min",
        preparationTimeRaw: 45,
        servingCount: "4",
        servingCountRaw: 4,
        tags: [],
        ingredients: [
            .init(id: "i5", name: "čočka", isGroup: false, amount: "250", amountRaw: 250, amountUnit: "g"),
            .init(id: "i6", name: "cibule", isGroup: false, amount: "1", amountRaw: 1, amountUnit: "ks"),
        ],
        cookedHistory: []
    ),
    Recipe(
        id: "63506df6f463890829ae047d",
        title: "Řízek",
        imageUrl: nil,
        directions: nil,
        sideDish: "bramborový salát",
        preparationTime: nil,
        preparationTimeRaw: nil,
        servingCount: nil,
        servingCountRaw: nil,
        tags: [],
        ingredients: [],
        cookedHistory: []
    ),
    Recipe(
        id: "63506df6f463890829ae047e",
        title: "Špagety carbonara",
        imageUrl: nil,
        directions: "Uvařte špagety al dente.",
        sideDish: nil,
        preparationTime: "25 min",
        preparationTimeRaw: 25,
        servingCount: "2",
        servingCountRaw: 2,
        tags: [],
        ingredients: [
            .init(id: "i7", name: "špagety", isGroup: false, amount: "200", amountRaw: 200, amountUnit: "g"),
            .init(id: "i8", name: "slanina", isGroup: false, amount: "100", amountRaw: 100, amountUnit: "g"),
        ],
        cookedHistory: []
    ),
]

// MARK: - Stub services

final class PreviewRecipeService: RecipeService {
    /// `nil` never emits, which leaves the store in its initial loading state.
    private let result: Result<[Recipe], Error>?

    init(result: Result<[Recipe], Error>?) {
        self.result = result
    }

    func recipeUpdates() -> AsyncStream<Result<[Recipe], Error>> {
        AsyncStream { continuation in
            if let result {
                continuation.yield(result)
            }
        }
    }

    func refreshRecipes() async throws {}

    func markCooked(recipeId: String, date: Date) async throws -> Recipe { previewRecipes[0] }
    func deleteCooked(recipeId: String, cookedId: String) async throws -> Recipe { previewRecipes[0] }
    func createRecipe(_ draft: RecipeDraft, imageId: String?) async throws -> Recipe { previewRecipes[0] }
    func updateRecipe(id: String, draft: RecipeDraft, imageId: String?) async throws -> Recipe { previewRecipes[0] }
    func deleteRecipe(id: String) async throws {}
}

final class PreviewAuthService: AuthService {
    private let tokenStore: any TokenStore
    private let displayName: String

    init(isLoggedIn: Bool, displayName: String = "Jakub") {
        self.tokenStore = InMemoryTokenStore(accessToken: isLoggedIn ? "preview-token" : nil)
        self.displayName = displayName
    }

    var accessToken: String? { tokenStore.accessToken }

    func logIn(username: String, password: String) async throws -> String {
        try await Task.sleep(for: .seconds(1))

        guard password == "heslo" else { throw AuthError.invalidCredentials }

        return "preview-token"
    }

    func storeAccessToken(_ token: String) { tokenStore.setAccessToken(token) }
    func clearAccessToken() { tokenStore.setAccessToken(nil) }
    func loadDisplayName() async throws -> String { displayName }
}

// MARK: - Preview environment

extension View {
    /// Injects stores backed by stub services, so previews exercise the same code
    /// path as the app without touching the network.
    func previewStores(
        status: LoadingStatus = .data,
        isLoggedIn: Bool = false,
        recipes: [Recipe] = previewRecipes
    ) -> some View {
        modifier(PreviewStoresModifier(status: status, isLoggedIn: isLoggedIn, recipes: recipes))
    }
}

@MainActor
private struct PreviewStoresModifier: ViewModifier {
    @State private var routing = Routing()
    @State private var recipeStore: RecipeStore
    @State private var currentUserStore: CurrentUserStore

    init(status: LoadingStatus, isLoggedIn: Bool, recipes: [Recipe]) {
        let result: Result<[Recipe], Error>? = switch status {
        case .data: .success(recipes)
        case .error(let message): .failure(RecipeServiceError.noData(message))
        case .loading: nil
        }

        _recipeStore = State(initialValue: RecipeStore(service: PreviewRecipeService(result: result)))
        _currentUserStore = State(initialValue: CurrentUserStore(service: PreviewAuthService(isLoggedIn: isLoggedIn)))
    }

    func body(content: Content) -> some View {
        content
            .environment(routing)
            .environment(recipeStore)
            .environment(currentUserStore)
            .task {
                recipeStore.startWatching()
                await currentUserStore.loadCurrentUserIfNeeded()
            }
    }
}

#endif
