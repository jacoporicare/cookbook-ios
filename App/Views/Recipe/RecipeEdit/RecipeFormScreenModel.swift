//
//  RecipeFormScreenModel.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 13.10.2022.
//

import Apollo
import SwiftUI

class RecipeFormScreenModel: ObservableObject {
    @Published var isSaving = false
    @Published var isError = false
        
    func save(id: String? = nil, data recipe: RecipeEdit, image: UIImage?, completionHandler: @escaping (Recipe) -> Void) {
        isSaving = true
            
        var files: [GraphQLFile] = []
        if let data = image?.jpegData(compressionQuality: 100) {
            files.append(.init(fieldName: "image", originalName: "image", data: data))
        }
            
        if let id {
            let mutation = UpdateRecipeMutation(
                id: id,
                recipe: recipe.toRecipeInput(),
                image: image != nil ? "image" : nil
            )
                
            Network.shared.apollo.upload(operation: mutation, files: files) { [weak self] result in
                self?.isSaving = false
                    
                switch result {
                case .success(let result):
                    guard let recipe = result.data?.updateRecipe else { fallthrough }
                    completionHandler(Recipe(from: recipe.fragments.recipeDetails))
                case .failure:
                    self?.isError = true
                }
            }
        } else {
            let mutation = CreateRecipeMutation(
                recipe: recipe.toRecipeInput(),
                image: image != nil ? "image" : nil
            )
                
            Network.shared.apollo.upload(operation: mutation, files: files) { [weak self] result in
                self?.isSaving = false
                    
                switch result {
                case .success(let result):
                    guard let recipe = result.data?.createRecipe else { fallthrough }
                    completionHandler(Recipe(from: recipe.fragments.recipeDetails))
                case .failure:
                    self?.isError = true
                }
            }
        }
    }
        
    func delete(id: String, completionHandler: @escaping Callback) {
        isSaving = true
            
        let mutation = DeleteRecipeMutation(id: id)
            
        Network.shared.apollo.perform(mutation: mutation) { [weak self] result in
            self?.isSaving = false
                
            switch result {
            case .success(let result):
                guard let _ = result.data?.deleteRecipe else { fallthrough }
                completionHandler()
            case .failure:
                self?.isError = true
            }
        }
    }
}
