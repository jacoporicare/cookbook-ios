//
//  Routing.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 26.09.2022.
//

import Foundation

class Routing: ObservableObject {
    @Published var recipeListStack: [Recipe] = []
    @Published var sousVideListStack: [Recipe] = []

    func popToRoot(_ tab: AppTab) {
        switch tab {
        case .recipes:
            recipeListStack = []
        case .sousVideRecipes:
            sousVideListStack = []
        case .settings, .search:
            break
        }
    }
}
