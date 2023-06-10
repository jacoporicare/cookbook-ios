//
//  RecipeDetailModel.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 02.11.2022.
//

import API
import Foundation

class RecipeDetailModel: ObservableObject {
    @Published var isSaving: Bool = false

    private lazy var UTCCalendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = .gmt
        return cal
    }()

    func recipeCooked(id: String, date: Date, completionHandler: @escaping (Recipe?) -> Void) {
        isSaving = true

        let dateUTCMidnight = UTCCalendar.startOfDay(for: date)
        let mutation = RecipeCookedMutation(id: id, date: dateUTCMidnight)

        Network.shared.apollo.perform(mutation: mutation) { [weak self] result in
            self?.isSaving = false

            switch result {
            case .success(let result):
                guard let recipe = result.data?.recipeCooked else { fallthrough }
                completionHandler(Recipe(from: recipe.fragments.recipeDetails))
            case .failure:
                completionHandler(nil)
            }
        }
    }

    func deleteRecipeCooked(recipeId: String, cookedId: String, completionHandler: @escaping (Recipe?) -> Void) {
        let mutation = DeleteRecipeCookedMutation(recipeId: recipeId, cookedId: cookedId)

        Network.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .success(let result):
                guard let recipe = result.data?.deleteRecipeCooked else { fallthrough }
                completionHandler(Recipe(from: recipe.fragments.recipeDetails))
            case .failure:
                completionHandler(nil)
            }
        }
    }
}
