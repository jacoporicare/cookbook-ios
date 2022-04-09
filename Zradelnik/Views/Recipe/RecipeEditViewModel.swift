//
//  RecipeEditViewModel.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 09.04.2022.
//

import Apollo
import Foundation
import SwiftUI

class RecipeEditViewModel: ObservableObject {
    private var request: Cancellable?

    @Published var draftRecipe = RecipeEdit.default
    @Published var originalRecipe: RecipeDetail?
    @Published var showingImagePicker = false
    @Published var inputImage: UIImage?
    @Published var saving = false
    @Published var error = false

    var saveDisabled: Bool {
        draftRecipe.title.isEmpty
    }
    
    func setRecipe(recipe: RecipeDetail?) {
        guard let recipe = recipe else { return }
        draftRecipe = RecipeEdit(from: recipe)
        originalRecipe = recipe
    }

    func save(success: @escaping () -> Void) {
        // TODO: temp
        guard let originalRecipe = originalRecipe else { return }

        saving = true
        error = false

        let mutation = UpdateRecipeMutation(
            id: originalRecipe.id,
            recipe: draftRecipe.toRecipeInput(),
            image: inputImage != nil ? "image" : nil
        )

        var files: [GraphQLFile] = []
        if let data = inputImage?.jpegData(compressionQuality: 80) {
            files.append(GraphQLFile(fieldName: "image", originalName: "image", data: data))
        }

        request = Network.shared.apollo.upload(operation: mutation, files: files) { [weak self] result in
            self?.saving = false

            switch result {
            case .success(let result):
                guard let _ = result.data else { fallthrough }
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
