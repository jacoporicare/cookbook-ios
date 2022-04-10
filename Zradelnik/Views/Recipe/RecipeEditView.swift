//
//  RecipeEditView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 08.04.2022.
//

import SwiftUI

struct RecipeEditView: View {
    @Environment(\.editMode) private var editMode
    @StateObject private var viewModel = RecipeEditViewModel()

    private var numFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        return formatter
    }

    var recipe: RecipeDetail? = nil
    let refetch: () -> Void

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
                    //.frame(height: 390)
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
                        viewModel.save {
                            refetch()
                            editMode?.animation().wrappedValue = .inactive
                        }
                    }
                    .disabled(!viewModel.isValid)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Zrušit") {
                        editMode?.animation().wrappedValue = .inactive
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
struct RecipeEditView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RecipeEditView(recipe: recipeDetailPreviewData[0]) {}
            RecipeEditView {}
        }
    }
}
#endif
