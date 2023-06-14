//
//  RecipeFormScreenView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 11.04.2022.
//

import CachedAsyncImage
import SwiftUI

struct RecipeFormScreenView: View {
    let recipe: Recipe?
    let isInstantPotNewRecipe: Bool?
    let onSave: (Recipe) -> Void
    let onCancel: Callback
    let onDelete: Callback?
    
    @StateObject private var vm: RecipeFormScreenModel
    
    @State private var ingredientEditMode = EditMode.inactive
    @State private var isImagePickerPresented = false
    @State private var isDeleteConfirmationPresented = false
    @State private var isCancelConfirmationPresented = false
    
    init(
        recipe: Recipe? = nil,
        isInstantPotNewRecipe: Bool? = nil,
        onSave: @escaping (Recipe) -> Void,
        onCancel: @escaping Callback,
        onDelete: Callback? = nil
    ) {
        self.recipe = recipe
        self.isInstantPotNewRecipe = isInstantPotNewRecipe
        self.onSave = onSave
        self.onCancel = onCancel
        self.onDelete = onDelete
        
        _vm = StateObject(wrappedValue: RecipeFormScreenModel(recipe: recipe, isInstantPotNewRecipe: isInstantPotNewRecipe))
    }
    
    var body: some View {
        RecipeFormTemplateView(
            draftRecipe: $vm.draftRecipe,
            inputImage: $vm.inputImage,
            isImagePickerPresented: $isImagePickerPresented,
            ingredientEditMode: $ingredientEditMode,
            isDeleteConfirmationPresented: $isDeleteConfirmationPresented,
            isCancelConfirmationPresented: $isCancelConfirmationPresented,
            isError: $vm.isError,
            recipe: vm.recipe,
            isValid: vm.isValid,
            isDirty: vm.isDirty,
            isSaving: vm.isSaving,
            onSave: { vm.save(completionHandler: onSave) },
            onCancel: onCancel,
            onDelete: { vm.delete(completionHandler: onDelete ?? {}) }
        )
        .environment(\.editMode, $ingredientEditMode)
    }
}
