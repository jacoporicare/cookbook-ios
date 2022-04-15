//
//  URLCache+imageCache.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 15.04.2022.
//

import Foundation

extension URLCache {
    static let imageCache = URLCache(memoryCapacity: 10 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024)
}
