//
//  RecipeEdit.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 08.04.2022.
//

import Foundation

struct RecipeEdit {
    var title: String = ""
    var directions: String = ""
    var sideDish: String = ""
    var preparationTime: Int = 0
    var servingCount: Int = 0

    static let `default` = RecipeEdit()

    init() {}

    init(from recipe: RecipeDetail) {
        title = recipe.title
        directions = recipe.directions ?? ""
        sideDish = recipe.sideDish ?? ""
        preparationTime = recipe.preparationTime ?? 0
        servingCount = recipe.servingCount ?? 0
    }
}
