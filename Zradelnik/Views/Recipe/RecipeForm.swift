//
//  RecipeForm.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 11.04.2022.
//

import SwiftUI

struct RecipeForm: View {
    @StateObject private var viewModel = RecipeFormViewModel()

    var recipe: RecipeDetail? = nil
    let refetch: () -> Void
    let onSave: (String) -> Void
    let onCancel: () -> Void

    var body: some View {
        Form {
            HStack {
                Spacer()
                VStack {
                    VStack {
                        if let image = viewModel.inputImage {
                            Image(uiImage: image).centerCropped()
                        } else if let imageUrl = viewModel.originalRecipe?.fullImageUrl {
                            AsyncImage(url: URL(string: imageUrl)) { image in
                                image.centerCropped()
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                    // .frame(height: 390)
                    .onTapGesture {
                        viewModel.showingImagePicker = true
                    }

                    Button("Změnit fotku") {
                        viewModel.showingImagePicker = true
                    }
                }
                Spacer()
            }

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
        }
        // .buttonStyle(BorderlessButtonStyle()) // Fix non-clickable buttons in Form
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
        .alert("Při ukládání nastala chyba.", isPresented: $viewModel.error) {}
    }
}

#if DEBUG
struct RecipeForm_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RecipeForm(recipe: recipeDetailPreviewData[0]) {} onSave: { _ in } onCancel: {}
            RecipeForm {} onSave: { _ in } onCancel: {}
        }
    }
}
#endif