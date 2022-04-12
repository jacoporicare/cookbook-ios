//
//  RecipeForm.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 11.04.2022.
//

import SwiftUI

struct RecipeForm: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = RecipeFormViewModel()
    @State private var showingDeleteConfirmation = false

    var recipe: RecipeDetail? = nil
    let refetch: () -> Void
    let onSave: (String) -> Void
    let onCancel: () -> Void

    var body: some View {
        Form {
            if let image = viewModel.inputImage {
                Image(uiImage: image)
                    .centerCropped()
                    .listRowInsets(EdgeInsets())
                    .frame(height: 390)
                    .onTapGesture {
                        viewModel.showingImagePicker = true
                    }
            } else if let imageUrl = viewModel.originalRecipe?.fullImageUrl {
                ZStack {
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image.centerCropped()
                    } placeholder: {
                        ProgressView()
                    }
                }
                .listRowInsets(EdgeInsets())
                .frame(height: 390)
                .frame(maxWidth: .infinity, alignment: .center)
                .onTapGesture {
                    viewModel.showingImagePicker = true
                }
            }

            Button(viewModel.inputImage == nil && viewModel.originalRecipe?.fullImageUrl == nil ? "Vybrat fotku" : "Změnit fotku") {
                viewModel.showingImagePicker = true
            }
            .frame(maxWidth: .infinity, alignment: .center)

            Section("Základní informace") {
                TextField("Název", text: $viewModel.draftRecipe.title)

                HStack {
                    Text("Doba přípravy")
                    Spacer()
                    TextField("", text: $viewModel.draftRecipe.preparationTime)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: viewModel.draftRecipe.preparationTime) { newValue in
                            if !newValue.isEmpty, Int(newValue) == nil {
                                viewModel.draftRecipe.preparationTime = newValue.filter { $0.isNumber }
                            }
                        }
                    Divider()
                    Text("min")
                }

                HStack {
                    Text("Počet porcí")
                    Spacer()
                    TextField("", text: $viewModel.draftRecipe.servingCount)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: viewModel.draftRecipe.servingCount) { newValue in
                            if !newValue.isEmpty, Int(newValue) == nil {
                                viewModel.draftRecipe.servingCount = newValue.filter { $0.isNumber }
                            }
                        }
                }
            }

            if viewModel.originalRecipe != nil {
                Button("Smazat recept") {
                    showingDeleteConfirmation = true
                }
                .foregroundColor(.red)
            }
        }
        .buttonStyle(BorderlessButtonStyle()) // Fix non-clickable buttons in Form
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.setRecipe(recipe: recipe)
        }
        .toolbar {
            Group {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Uložit") {
                        viewModel.save { id in
                            refetch()
                            onSave(id)
                        }
                    }
                    .disabled(!viewModel.isValid)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Zrušit") {
                        onCancel()
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.showingImagePicker) {
            ImagePicker(image: $viewModel.inputImage)
        }
        .disabled(viewModel.saving)
        .alert("Nastala chyba.", isPresented: $viewModel.error) {}
        .confirmationDialog("Opravdu smazat recept?", isPresented: $showingDeleteConfirmation) {
            Button("Smazat recept", role: .destructive) {
                viewModel.delete {
                    dismiss()
                }
            }
            Button("Zrušit", role: .cancel) {}
        }
    }
}

#if DEBUG
struct RecipeForm_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RecipeForm(recipe: RecipeDetail(from: recipeDetailPreviewData[0])) {} onSave: { _ in } onCancel: {}
            RecipeForm {} onSave: { _ in } onCancel: {}
        }
    }
}
#endif
