//
//  Recipe.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import Foundation

struct Recipe: Identifiable, Decodable, Hashable {
    static let sousVideTag = "sous-vide"

    let id: String
    let title: String
    // Only the S3 object-key prefix; the renditions live under it (see below).
    let imageUrl: String?
    let directions: String?
    let sideDish: String?
    let preparationTime: String?
    let preparationTimeRaw: Int?
    let servingCount: String?
    let servingCountRaw: Int?
    let tags: [String]
    let ingredients: [Ingredient]
    let cookedHistory: [Cooked]

    var isForSousVide: Bool {
        tags.contains(Recipe.sousVideTag)
    }

    struct Ingredient: Identifiable, Decodable, Hashable {
        let id: String
        let name: String
        let isGroup: Bool
        let amount: String?
        let amountRaw: Double?
        let amountUnit: String?
    }

    struct Cooked: Identifiable, Decodable, Hashable {
        let id: String
        let date: Date
        let user: User?

        struct User: Identifiable, Decodable, Hashable {
            let id: String
            let displayName: String
        }
    }
}

extension Recipe {
    init(from recipe: RecipeDetails) {
        self.id = recipe.id
        self.title = recipe.title
        self.imageUrl = recipe.imageUrl
        self.directions = recipe.directions
        self.sideDish = recipe.sideDish
        self.preparationTime = recipe.preparationTime?.formattedTime()
        self.preparationTimeRaw = recipe.preparationTime
        self.servingCount = recipe.servingCount?.formatted()
        self.servingCountRaw = recipe.servingCount
        self.tags = recipe.tags
        self.ingredients = recipe.ingredients.map { Ingredient(from: $0) }
        self.cookedHistory = recipe.cookedHistory.map { Cooked(from: $0) }
    }
}

extension Recipe {
    // The API is out of the image read path: it returns a bare S3 prefix and the
    // pre-generated WebP renditions are served straight from the bucket as
    // <prefix>/<width>.webp. Keep in sync with RENDITION_WIDTHS in the API
    // (api/src/imageProcessing.ts) and the web loader (web/image-loader.js).
    private static let renditionWidths = [96, 384, 640, 828, 1080, 1920]

    /// 80x60pt thumbnail in the recipe list.
    var listImageUrl: String? { renditionUrl(forPixelWidth: 240) }

    /// ~181pt wide card in the two column grid.
    var gridImageUrl: String? { renditionUrl(forPixelWidth: 543) }

    /// Full width header on the detail and edit screens.
    var fullImageUrl: String? { renditionUrl(forPixelWidth: 1206) }

    // Same rule as the web's next/image loader: the smallest rendition at least as
    // wide as the space it fills. Widths assume a 3x display, as the sizes the old
    // server-side resizing asked for did.
    private func renditionUrl(forPixelWidth width: Int) -> String? {
        guard let imageUrl else { return nil }

        let rendition = Self.renditionWidths.first { $0 >= width } ?? Self.renditionWidths[Self.renditionWidths.endIndex - 1]

        return "\(imageUrl)/\(rendition).webp"
    }
}

extension Recipe.Ingredient {
    init(from ingredient: RecipeDetails.Ingredient) {
        self.id = ingredient.id
        self.name = ingredient.name
        self.isGroup = ingredient.isGroup
        self.amount = ingredient.amount?.formatted()
        self.amountRaw = ingredient.amount
        self.amountUnit = ingredient.amountUnit
    }
}

extension Recipe.Cooked {
    init(from cooked: RecipeDetails.CookedHistory) {
        self.id = cooked.id
        self.date = cooked.date
        self.user = cooked.user.map { User(from: $0) }
    }
}

extension Recipe.Cooked.User {
    init(from user: RecipeDetails.CookedHistory.User) {
        self.id = user.id
        self.displayName = user.displayName
    }
}

extension Recipe {
    func matches(_ string: String) -> Bool {
        string.isEmpty
            || title.localizedCaseInsensitiveContains(string)
            || ingredients.contains { $0.name.localizedCaseInsensitiveContains(string) }
    }
}

private extension Int {
    func formattedTime() -> String {
        let hours = Int(Double(self) / 60.0)
        let minutes = self % 60

        if hours > 0, minutes == 0 {
            return "\(hours) h"
        }

        if hours > 0, minutes > 0 {
            return "\(hours) h \(minutes) min"
        }

        return "\(minutes) min"
    }
}
