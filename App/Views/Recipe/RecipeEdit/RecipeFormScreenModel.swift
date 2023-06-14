//
//  RecipeFormScreenModel.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 13.10.2022.
//

import Apollo
import SwiftUI

class RecipeFormScreenModel: ObservableObject {
    @Published var draftRecipe = RecipeEdit.default
    @Published var inputImage: UIImage?
    @Published var isSaving = false
    @Published var isError = false
    
    let recipe: Recipe?
    let isInstantPotNewRecipe: Bool?
    
    var isValid: Bool {
        !draftRecipe.title.isEmpty && !draftRecipe.ingredients.contains { ingredient in
            !ingredient.amount.isEmpty && Double(ingredient.amount.replacingOccurrences(of: ",", with: ".")) == nil
        }
    }
    
    var isDirty: Bool {
        (recipe == nil && (
            (isInstantPotNewRecipe != true && draftRecipe != RecipeEdit.default)
                || (isInstantPotNewRecipe == true && draftRecipe != RecipeEdit.defaultInstantPot)
        ))
            || (recipe != nil && draftRecipe != RecipeEdit(from: recipe!))
            || inputImage != nil
    }
    
    init(recipe: Recipe?, isInstantPotNewRecipe: Bool?) {
        self.recipe = recipe
        self.isInstantPotNewRecipe = isInstantPotNewRecipe
        
        if let recipe {
            draftRecipe = RecipeEdit(from: recipe)
        }
        
        if isInstantPotNewRecipe == true {
            draftRecipe.isForInstantPot = true
        }
    }
        
    func save(completionHandler: @escaping (Recipe) -> Void) {
        isSaving = true
            
        var files: [GraphQLFile] = []
        if let data = inputImage?.jpegData(compressionQuality: 100) {
            files.append(.init(fieldName: "image", originalName: "image", data: data))
        }
            
        if let id = recipe?.id {
            let mutation = UpdateRecipeMutation(
                id: id,
                recipe: draftRecipe.toRecipeInput(),
                image: inputImage != nil ? "image" : nil
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
                recipe: draftRecipe.toRecipeInput(),
                image: inputImage != nil ? "image" : nil
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
        
    func delete(completionHandler: @escaping Callback) {
        guard let id = recipe?.id else {
            completionHandler()
            return
        }
        
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
