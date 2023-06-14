//
//  RecipeArrayExtension.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 14.06.2023.
//

import Foundation

private let alphabet = ["#", "A", "Á", "B", "C", "Č", "D", "Ď", "E", "É", "F", "G", "H", "CH", "I", "Í", "J", "K", "L", "M", "N", "O", "Ó", "P", "Q", "R", "Ř", "S", "Š", "T", "Ť", "U", "Ú", "V", "W", "X", "Y", "Ý", "Z", "Ž"]

extension [Recipe] {
    func groupedByFirstLetter() -> [RecipeGroup] {
        return Dictionary(grouping: self) { recipe in
            alphabet.contains(String(recipe.title.uppercased().prefix(2)))
                ? String(recipe.title.uppercased().prefix(2))
                : alphabet.contains(String(recipe.title.uppercased().prefix(1)))
                ? String(recipe.title.uppercased().prefix(1))
                : "#"
        }
        .map { key, value in RecipeGroup(id: key, recipes: value) }
        .sorted { $0.id.compare($1.id, locale: zradelnikLocale) == .orderedAscending }
    }
}
