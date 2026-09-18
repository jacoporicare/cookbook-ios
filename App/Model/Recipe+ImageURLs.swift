//
//  Recipe+ImageURLs.swift
//  Zradelnik
//

import Foundation

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

    /// Full width header on the detail and form screens.
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
