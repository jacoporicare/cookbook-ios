//
//  AppServices.swift
//  Zradelnik
//

import SwiftUI

/// The composition root. This is the only place that knows which concrete service
/// implementations the app runs with; everything else takes a protocol, either
/// through an initialiser (stores) or through the environment (views).
struct AppServices {
    let recipes: any RecipeService
    let auth: any AuthService
    let imageUploader: any ImageUploader

    static func live() -> AppServices {
        let tokenStore = KeychainTokenStore()
        let client = ApolloClientFactory.make(tokenStore: tokenStore)

        return AppServices(
            recipes: ApolloRecipeService(client: client),
            auth: ApolloAuthService(client: client, tokenStore: tokenStore),
            imageUploader: S3ImageUploader(client: client)
        )
    }
}

// MARK: - Environment

// Only the services a view needs directly are exposed here. Recipe and auth calls
// go through the stores, which get their services injected at construction.
extension EnvironmentValues {
    @Entry var imageUploader: any ImageUploader = UnavailableImageUploader()
}

/// Environment default. A view that actually uploads gets the real uploader handed
/// to it from the composition root; this only keeps previews from hitting the network.
struct UnavailableImageUploader: ImageUploader {
    func upload(_ image: UIImage) async throws -> String {
        throw ImageUploadError.serverError("Nahrávání fotek není v tomto kontextu dostupné.")
    }
}
