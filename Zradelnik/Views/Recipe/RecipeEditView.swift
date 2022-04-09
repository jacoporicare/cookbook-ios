//
//  RecipeEditView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 08.04.2022.
//

import SwiftUI

struct RecipeEditView: View {
    @Environment(\.editMode) var editMode

    @StateObject private var viewModel = RecipeEditViewModel()

    let recipe: RecipeDetail?
    let refetch: () -> Void

    var body: some View {
        ScrollView {
            VStack {
                Group {
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
                .frame(height: 390)
                .onTapGesture {
                    viewModel.showingImagePicker = true
                }

                Button("Změnit fotku") {
                    viewModel.showingImagePicker = true
                }

//                Section("Základní informace") {
                TextField("Název", text: $viewModel.draftRecipe.title)
//                }
                Spacer()
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
        RecipeEditView(recipe: recipeDetailPreviewData[0]) {}
    }
}
#endif
