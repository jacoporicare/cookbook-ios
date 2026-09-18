//
//  LoadingStatus.swift
//  Zradelnik
//

import Foundation

enum LoadingStatus: Equatable {
    case loading
    case data
    case error(String)
}
