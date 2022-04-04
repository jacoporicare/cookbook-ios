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
                guard let data = result.data else { fallthrough }
                self.status = .data(data.recipes.map { Recipe($0) })
            case .failure:
                self.status = .error
            }
        }
    }
}
