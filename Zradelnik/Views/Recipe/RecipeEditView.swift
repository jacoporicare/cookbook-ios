//
//  RecipeEditView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 08.04.2022.
//

import SwiftUI

struct RecipeEditView: View {
    @Environment(\.editMode) var editMode
    
    private var originalRecipe: RecipeDetail?
    
    @State private var draftRecipe = RecipeEdit.default
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    init(recipe: RecipeDetail? = nil) {
        guard let recipe = recipe else { return }
        _draftRecipe = State(initialValue: RecipeEdit(from: recipe))
        originalRecipe = recipe
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Group {
                    if let image = image {
                        image.centerCropped()
                    } else if let imageUrl = originalRecipe?.fullImageUrl {
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image.centerCropped()
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                .frame(height: 390)
                .onTapGesture {
                    showingImagePicker = true
                }
                
                Button("Změnit fotku") {
                    showingImagePicker = true
                }
                
//                Section("Základní informace") {
                TextField("Název", text: $draftRecipe.title)
//                }
                Spacer()
            }
        }
        // .buttonStyle(BorderlessButtonStyle()) // Fix non-clickable buttons in Form
        .navigationBarBackButtonHidden(true)
        .toolbar {
            Group {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Uložit") {
                        editMode?.animation().wrappedValue = .inactive
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Zrušit") {
                        editMode?.animation().wrappedValue = .inactive
                    }
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
        .onChange(of: inputImage) { _ in
            guard let inputImage = inputImage else { return }
            image = Image(uiImage: inputImage)
        }
    }
}

#if DEBUG
struct RecipeEditView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeEditView(recipe: recipeDetailPreviewData[0])
    }
}
#endif
