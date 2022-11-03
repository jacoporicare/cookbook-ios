//
//  RecipeDetailView+ViewModel.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 02.11.2022.
//

import API
import Foundation

extension RecipeDetailView {
    class ViewModel: ObservableObject {
        @Published var isSaving: Bool = false
        
        func recipeCooked(id: String, date: Date, completionHandler: @escaping (Recipe?) -> Void) {
            isSaving = true
            
            let mutation = RecipeCookedMutation(id: id, date: date)
            
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
    }
}
