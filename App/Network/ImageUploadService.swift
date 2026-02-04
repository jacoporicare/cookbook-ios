//
//  ImageUploadService.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 04.02.2026.
//

import Foundation
import UIKit

struct ImageUploadResult: Decodable {
    let imageId: String
}

enum ImageUploadError: Error {
    case noToken
    case invalidImage
    case serverError(String)
}

class ImageUploadService {
    static let shared = ImageUploadService()

    private init() {}

    func upload(image: UIImage) async throws -> String {
        guard let token = ZKeychain.accessToken else {
            throw ImageUploadError.noToken
        }

        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw ImageUploadError.invalidImage
        }

        let baseUrl: String = try Configuration.value(for: "API_BASE_URL")
        let url = URL(string: "https://\(baseUrl)/api/upload/image")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ImageUploadError.serverError("Invalid response")
        }

        guard httpResponse.statusCode == 200 else {
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw ImageUploadError.serverError("Status \(httpResponse.statusCode): \(message)")
        }

        let result = try JSONDecoder().decode(ImageUploadResult.self, from: data)
        return result.imageId
    }
}
