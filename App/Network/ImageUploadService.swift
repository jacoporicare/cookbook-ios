//
//  ImageUploadService.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 04.02.2026.
//

import Foundation
import UIKit

enum ImageUploadError: Error {
    case invalidImage
    case serverError(String)
}

class ImageUploadService {
    static let shared = ImageUploadService()

    private static let contentType = "image/jpeg"

    private init() {}

    // The server presigns a direct-to-S3 staging upload. We PUT the original there
    // and hand the returned key to createRecipe/updateRecipe as imageId, which promotes it.
    func upload(image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw ImageUploadError.invalidImage
        }

        let target = try await createUploadTarget()

        guard let url = URL(string: target.uploadUrl) else {
            throw ImageUploadError.serverError("Invalid upload URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue(Self.contentType, forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.upload(for: request, from: imageData)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ImageUploadError.serverError("Invalid response")
        }

        guard (200 ..< 300).contains(httpResponse.statusCode) else {
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw ImageUploadError.serverError("Status \(httpResponse.statusCode): \(message)")
        }

        return target.key
    }

    private func createUploadTarget() async throws -> (key: String, uploadUrl: String) {
        try await withCheckedThrowingContinuation { continuation in
            Network.shared.apollo.perform(
                mutation: CreateImageUploadMutation(contentType: Self.contentType)
            ) { result in
                switch result {
                case .success(let response):
                    guard let target = response.data?.createImageUpload else {
                        let message = response.errors?.first?.message ?? "Unknown error"
                        continuation.resume(throwing: ImageUploadError.serverError(message))
                        return
                    }

                    continuation.resume(returning: (target.key, target.uploadUrl))
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
