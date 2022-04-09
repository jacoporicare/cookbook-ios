//
//  RecipeDetailViewModel.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import Apollo
import Foundation

class RecipeViewModel: ObservableObject {
    private var request: Cancellable?

    @Published var recipe: LoadingStatus<RecipeDetail> = .loading

    func fetch(id: String) {
        request = Network.shared.apollo.fetch(query: RecipeDetailQuery(id: id)) { [weak self] result in
            switch result {
            case .success(let result):
                guard let recipe = result.data?.recipe else { fallthrough }
                self?.recipe = .data(RecipeDetail(recipe))
            case .failure:
                self?.recipe = .error
            }
        }
    }

    deinit {
        self.request?.cancel()
    }
}
