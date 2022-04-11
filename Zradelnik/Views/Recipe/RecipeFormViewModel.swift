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
    private var request: Cancellable?

    @Published var draftRecipe = RecipeEdit.default
    @Published var originalRecipe: RecipeDetail?
    @Published var showingImagePicker = false
    @Published var inputImage: UIImage?
    @Published var saving = false
    @Published var error = false

    var isValid: Bool {
        !draftRecipe.title.isEmpty
    }

    func setRecipe(recipe: RecipeDetail?) {
        guard let recipe = recipe else { return }
        draftRecipe = RecipeEdit(from: recipe)
        originalRecipe = recipe
    }

    func save(success: @escaping (String) -> Void) {
        saving = true
        error = false

        var files: [GraphQLFile] = []
        if let data = inputImage?.jpegData(compressionQuality: 80) {
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
                    guard let recipe = result.data else { fallthrough }
                    success(recipe.updateRecipe.id)
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
                    guard let recipe = result.data else { fallthrough }
                    success(recipe.createRecipe.id)
                case .failure:
                    self?.error = true
                }
            }
        }
    }

    deinit {
        request?.cancel()
    }
}
