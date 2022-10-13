//
//  RecipeForm+ViewModel.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 13.10.2022.
//

import Apollo
import SwiftUI

extension RecipeForm {
    class ViewModel: ObservableObject {
        @Published var recipe: Recipe?
        @Published var draftRecipe = RecipeEdit.default
        @Published var inputImage: UIImage?
        @Published var isSaving = false
        @Published var isError = false
        @Published var onSave: ((Recipe) -> Void)?
        @Published var onDelete: (() -> Void)?
        
        var isValid: Bool {
            !draftRecipe.title.isEmpty && !draftRecipe.ingredients.contains { ingredient in
                !ingredient.amount.isEmpty && Double(ingredient.amount.replacingOccurrences(of: ",", with: ".")) == nil
            }
        }
        
        var isDirty: Bool {
            (recipe == nil && draftRecipe != RecipeEdit.default)
                || (recipe != nil && draftRecipe != RecipeEdit(from: recipe!))
                || inputImage != nil
        }
        
        func save() {
            isSaving = true
            
            var files: [GraphQLFile] = []
            if let data = inputImage?.jpegData(compressionQuality: 100) {
                files.append(.init(fieldName: "image", originalName: "image", data: data))
            }
            
            if let recipe {
                let mutation = UpdateRecipeMutation(
                    id: recipe.id,
                    recipe: draftRecipe.toRecipeInput(),
                    image: inputImage != nil ? "image" : nil
                )
                
                Network.shared.apollo.upload(operation: mutation, files: files) { result in
                    self.isSaving = false
                    
                    switch result {
                    case .success(let result):
                        guard let recipe = result.data?.updateRecipe else { fallthrough }
                        self.onSave?(Recipe(from: recipe.fragments.recipeDetails))
                    case .failure:
                        self.isError = true
                    }
                }
            } else {
                let mutation = CreateRecipeMutation(
                    recipe: draftRecipe.toRecipeInput(),
                    image: inputImage != nil ? "image" : nil
                )
                
                Network.shared.apollo.upload(operation: mutation, files: files) { result in
                    self.isSaving = false
                    
                    switch result {
                    case .success(let result):
                        guard let recipe = result.data?.createRecipe else { fallthrough }
                        self.onSave?(Recipe(from: recipe.fragments.recipeDetails))
                    case .failure:
                        self.isError = true
                    }
                }
            }
        }
        
        func delete() {
            guard let recipe else { return }
            
            isSaving = true
            
            let mutation = DeleteRecipeMutation(id: recipe.id)
            
            Network.shared.apollo.perform(mutation: mutation) { result in
                self.isSaving = false
                
                switch result {
                case .success(let result):
                    guard let _ = result.data?.deleteRecipe else { fallthrough }
                    self.onDelete?()
                case .failure:
                    self.isError = true
                }
            }
        }
    }
}
