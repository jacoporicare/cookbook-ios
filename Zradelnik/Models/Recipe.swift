//
//  Recipe.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import Foundation

struct Recipe: Identifiable, Decodable {
    var id: String
    var title: String
    var thumbImageUrl: String?
    
    init(_ recipe: RecipeListQuery.Data.Recipe) {
        self.id = recipe.id
        self.title = recipe.title
        self.thumbImageUrl = recipe.thumbImageUrl
    }
}
