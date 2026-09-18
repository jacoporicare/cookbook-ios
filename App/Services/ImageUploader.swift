//
//  ImageUploader.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 04.02.2026.
//

import API
import Apollo
import Foundation
import UIKit

enum ImageUploadError: LocalizedError {
    case invalidImage
    case serverError(String)

    var errorDescription: String? {
        switch self {
        case .invalidImage:
            "Fotku se nepodařilo zpracovat."
        case .serverError(let message):
            message
        }
    }
}

protocol ImageUploader {
    /// Uploads the image and returns the key to hand to create/update as `imageId`.
    func upload(_ image: UIImage) async throws -> String
}

final class S3ImageUploader: ImageUploader {
    private static let contentType = "image/jpeg"
    private static let compressionQuality: CGFloat = 0.8

    private let client: ApolloClient
    private let session: URLSession

    init(client: ApolloClient, session: URLSession = .shared) {
        self.client = client
        self.session = session
    }

    // The server presigns a direct-to-S3 staging upload. We PUT the original there
    // and hand the returned key to createRecipe/updateRecipe as imageId, which promotes it.
    func upload(_ image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: Self.compressionQuality) else {
            throw ImageUploadError.invalidImage
        }

        let target = try await createUploadTarget()

        guard let url = URL(string: target.uploadUrl) else {
            throw ImageUploadError.serverError("Neplatná adresa pro nahrání.")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue(Self.contentType, forHTTPHeaderField: "Content-Type")

        let (data, response) = try await session.upload(for: request, from: imageData)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ImageUploadError.serverError("Neplatná odpověď serveru.")
        }

        guard (200 ..< 300).contains(httpResponse.statusCode) else {
            let message = String(data: data, encoding: .utf8) ?? "Neznámá chyba"
            throw ImageUploadError.serverError("Status \(httpResponse.statusCode): \(message)")
        }

        return target.key
    }

    private func createUploadTarget() async throws -> (key: String, uploadUrl: String) {
        let response = try await client.perform(mutation: CreateImageUploadMutation(contentType: Self.contentType))

        guard let target = response.data?.createImageUpload else {
            throw ImageUploadError.serverError(response.errors?.first?.message ?? "Neznámá chyba")
        }

        return (target.key, target.uploadUrl)
    }
}
