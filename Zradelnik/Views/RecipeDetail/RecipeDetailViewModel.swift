//
//  RecipeDetailViewModel.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import Foundation

final class RecipeDetailViewModel: ObservableObject {
    @Published var status: LoadingStatus<DetailedRecipe> = .loading
    
    func fetch(id: String) {
        Network.shared.apollo.fetch(query: RecipeDetailQuery(id: id)) { result in
            switch result {
            case .success(let result):
                guard let recipe = result.data?.recipe else { fallthrough }
                self.status = .data(DetailedRecipe(recipe))
            case .failure:
                self.status = .error
            }
        }
    }
}
