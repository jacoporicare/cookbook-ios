//
//  RecipeEditViewModel.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 09.04.2022.
//

import Apollo
import Foundation
import SwiftUI

class RecipeFormViewModel: ObservableObject {
    @Published var draftRecipe = RecipeEdit.default
    @Published var originalRecipe: Recipe?
    @Published var showingImagePicker = false
    @Published var inputImage: UIImage?
    @Published var saving = false
    @Published var error = false

    var isValid: Bool {
        !draftRecipe.title.isEmpty && !draftRecipe.ingredients.contains(where: { ingredient in
            !ingredient.amount.isEmpty && Double(ingredient.amount.replacingOccurrences(of: ",", with: ".")) == nil
        })
    }

    var isDirty: Bool {
        (originalRecipe == nil && draftRecipe != RecipeEdit.default) ||
            (originalRecipe != nil && draftRecipe != RecipeEdit(from: originalRecipe!))
    }

    private var request: Cancellable?

    func setRecipe(recipe: Recipe?) {
        guard let recipe = recipe else { return }
        draftRecipe = RecipeEdit(from: recipe)
        originalRecipe = recipe
    }

    func save(success: @escaping (String) -> Void) {
        saving = true

        var files: [GraphQLFile] = []
        if let data = inputImage?.jpegData(compressionQuality: 100) {
            files.append(GraphQLFile(fieldName: "image", originalName: "image", data: data))
        }

        if let originalRecipe = originalRecipe {
            let mutation = UpdateRecipeMutation(
                id: originalRecipe.id,
                recipe: draftRecipe.toRecipeInput(),
                image: inputImage != nil ? "image" : nil
            )

            request = Network.shared.apollo.upload(operation: mutation, files: files) { [weak self] result in
                self?.saving = false

                switch result {
                case .success(let result):
                    guard let recipe = result.data?.updateRecipe else { fallthrough }
                    success(recipe.fragments.recipeDetails.id)
                case .failure:
                    self?.error = true
                }
            }
        } else {
            let mutation = CreateRecipeMutation(
                recipe: draftRecipe.toRecipeInput(),
                image: inputImage != nil ? "image" : nil
            )

            request = Network.shared.apollo.upload(operation: mutation, files: files) { [weak self] result in
                self?.saving = false

                switch result {
                case .success(let result):
                    guard let recipe = result.data?.createRecipe else { fallthrough }
                    success(recipe.fragments.recipeDetails.id)
                case .failure:
                    self?.error = true
                }
            }
        }
    }

    func delete(success: @escaping () -> Void) {
        guard let originalRecipe = originalRecipe else {
            return
        }

        saving = true

        let mutation = DeleteRecipeMutation(id: originalRecipe.id)

        request = Network.shared.apollo.perform(mutation: mutation) { [weak self] result in
            self?.saving = false

            switch result {
            case .success(let result):
                guard let _ = result.data?.deleteRecipe else { fallthrough }
                success()
            case .failure:
                self?.error = true
            }
        }
    }

    deinit {
        request?.cancel()
    }
}
