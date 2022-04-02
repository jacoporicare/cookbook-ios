//
//  RecipeListViewModel.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import Foundation

final class RecipeDetailViewModel: ObservableObject {
    @Published var status: LoadingStatus<DetailedRecipe> = .loading

    func fetch(_ id: String) {
        Network.shared.apollo.fetch(query: RecipeDetailQuery(id: id)) { result in
            switch result {
            case .success(let result):
                if let recipe = result.data?.recipe {
                    self.status = .data(DetailedRecipe(recipe))
                } else {
                    self.status = .error
                }
            case .failure:
                self.status = .error
            }
        }
    }
}
