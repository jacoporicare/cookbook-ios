//
//  RecipeDetailViewModel.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import Foundation

final class RecipeViewModel: ObservableObject {
    @Published var recipe: LoadingStatus<RecipeDetail> = .loading
    
    func fetch(id: String) {
        Network.shared.apollo.fetch(query: RecipeDetailQuery(id: id)) { result in
            switch result {
            case .success(let result):
                guard let recipe = result.data?.recipe else { fallthrough }
                self.recipe = .data(RecipeDetail(recipe))
            case .failure:
                self.recipe = .error
            }
        }
    }
}
