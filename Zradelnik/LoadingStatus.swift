//
//  ViewModelLoadingStatus.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import Foundation

enum LoadingStatus<Data> {
    case data(Data)
    case loading
    case error
}
