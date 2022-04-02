//
//  RecipeListViewModel.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import Foundation

final class RecipeListViewModel: ObservableObject {
    @Published var status: LoadingStatus<[Recipe]> = .loading

    func fetch() {
        Network.shared.apollo.fetch(query: RecipeListQuery()) { result in
            switch result {
            case .success(let result):
                if let data = result.data {
                    self.status = .data(data.recipes.map { Recipe($0) })
                } else {
                    self.status = .error
                }
            case .failure:
                self.status = .error
            }
        }
    }
}
