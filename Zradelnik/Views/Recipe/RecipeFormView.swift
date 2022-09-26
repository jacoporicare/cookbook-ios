//
//  RecipeFormView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 11.04.2022.
//

import CachedAsyncImage
import SwiftUI

struct RecipeFormView: View {
    var recipe: Recipe? = nil
    var onSave: (Recipe) -> Void
    var onCancel: () -> Void
    var onDelete: (() -> Void)? = nil

    @StateObject private var viewModel = ViewModel()
    @State private var showingDeleteConfirmation = false
    @State private var showingCancelConfirmation = false

    var body: some View {
        Form {
            if let image = viewModel.inputImage {
                Image(uiImage: image)
                    .centerCropped()
                    .listRowInsets(EdgeInsets())
                    .frame(height: 320)
                    .onTapGesture {
                        viewModel.showingImagePicker = true
                    }
            } else if let imageUrl = viewModel.originalRecipe?.fullImageUrl {
                ZStack {
                    CachedAsyncImage(url: URL(string: imageUrl), urlCache: .imageCache) { image in
                        image.centerCropped()
                    } placeholder: {
                        ProgressView()
                    }
                }
                .listRowInsets(EdgeInsets())
                .frame(height: 320)
                .frame(maxWidth: .infinity, alignment: .center)
                .onTapGesture {
                    viewModel.showingImagePicker = true
                }
            }

            Button(action: { viewModel.showingImagePicker = true }) {
                Spacer()
                Text(viewModel.inputImage == nil && viewModel.originalRecipe?.gridImageUrl == nil ? "Vybrat fotku" : "Změnit fotku")
                Spacer()
            }

            Section("Základní informace") {
                HStack {
                    Text("Název")
                    Spacer()
                    TextField("nezadáno", text: $viewModel.draftRecipe.title)
                        .multilineTextAlignment(.trailing)
                }

                HStack {
                    Text("Doba přípravy (min)")
                    Spacer()
                    TextField("nezadáno", text: $viewModel.draftRecipe.preparationTime)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: viewModel.draftRecipe.preparationTime) { newValue in
                            if !newValue.isEmpty, Int(newValue) == nil {
                                viewModel.draftRecipe.preparationTime = newValue.filter { $0.isNumber }
                            }
                        }
                }

                HStack {
                    Text("Počet porcí")
                    Spacer()
                    TextField("nezadáno", text: $viewModel.draftRecipe.servingCount)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: viewModel.draftRecipe.servingCount) { newValue in
                            if !newValue.isEmpty, Int(newValue) == nil {
                                viewModel.draftRecipe.servingCount = newValue.filter { $0.isNumber }
                            }
                        }
                }

                HStack {
                    Text("Příloha")
                    Spacer()
                    TextField("nezadáno", text: $viewModel.draftRecipe.sideDish)
                        .textInputAutocapitalization(.never)
                        .multilineTextAlignment(.trailing)
                }
            }

            ForEach($viewModel.draftRecipe.ingredients) { $ingredient in
                Section {
                    HStack {
                        TextField("Název", text: $ingredient.name)
                            .textInputAutocapitalization(.never)

                        Divider()

                        Button(action: {
                            viewModel.draftRecipe.ingredients = viewModel.draftRecipe.ingredients.filter { $0.id != $ingredient.id }
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .frame(width: 24)
                    }

                    GeometryReader { geo in
                        HStack(alignment: VerticalAlignment.center) {
                            if !$ingredient.isGroup.wrappedValue {
                                TextField("Množství", text: $ingredient.amount)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                    .frame(maxWidth: geo.size.width * 0.25)
                                    .foregroundColor(Double($ingredient.amount.wrappedValue.replacingOccurrences(of: ",", with: ".")) == nil ? .red : .none)

                                Divider()

                                TextField("Jednotka", text: $ingredient.amountUnit)
                                    .textInputAutocapitalization(.never)
                            } else {
                                Text("Skupina")
                                    .foregroundColor(.gray)
                                Spacer()
                            }

                            Divider()

                            Button(action: { $ingredient.isGroup.wrappedValue.toggle() }) {
                                Image(systemName: $ingredient.isGroup.wrappedValue ? "folder.fill" : "folder")
                            }
                            .frame(width: 24)
                        }
                    }
                } header: {
                    if viewModel.draftRecipe.ingredients.first == $ingredient.wrappedValue {
                        Text("Ingredience")
                    }
                }
            }

            Button(action: {
                viewModel.draftRecipe.ingredients.append(.init(name: "", isGroup: false, amount: "", amountUnit: ""))
            }) {
                Text("Přidat ingredienci")
                Spacer()
            }

            Section {
                TextField("Zde napište postup receptu.", text: $viewModel.draftRecipe.directions, axis: .vertical)
                    .lineLimit(3...)
            } header: {
                Text("Postup")
            } footer: {
                Text("Formátovat můžete pomocí [Markdown](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet).")
            }

            if viewModel.originalRecipe != nil {
                Button(action: { showingDeleteConfirmation = true }) {
                    Text("Smazat recept")
                    Spacer()
                }
                .foregroundColor(.red)
            }
        }
        .buttonStyle(.borderless) // Fix non-clickable buttons in Form
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.setRecipe(recipe: recipe)
        }
        .toolbar {
            Group {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Uložit") {
                        viewModel.save { recipe in
                            onSave(recipe)
                        }
                    }
                    .disabled(!viewModel.isValid)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Zrušit") {
                        if viewModel.isDirty {
                            showingCancelConfirmation = true
                        } else {
                            onCancel()
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.showingImagePicker) {
            ImagePicker(image: $viewModel.inputImage)
        }
        .disabled(viewModel.saving)
        .interactiveDismissDisabled(viewModel.isDirty)
        .alert("Nastala chyba.", isPresented: $viewModel.error) {}
        .confirmationDialog("Opravdu smazat recept?", isPresented: $showingDeleteConfirmation) {
            Button("Smazat recept", role: .destructive) {
                viewModel.delete {
                    onDelete?()
                }
            }
            Button("Zrušit", role: .cancel) {}
        }
        .confirmationDialog(viewModel.originalRecipe == nil ? "Opravdu zahodit nový recept?" : "Opravdu zahodit změny?", isPresented: $showingCancelConfirmation, titleVisibility: .visible) {
            Button("Zahodit změny", role: .destructive) {
                onCancel()
            }
            Button("Pokračovat v úpravách", role: .cancel) {}
        }
    }
}

#if DEBUG
struct RecipeForm_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RecipeFormView(recipe: Recipe(from: recipePreviewData[0])) { _ in } onCancel: {}
            RecipeFormView { _ in } onCancel: {}
        }
    }
}
#endif
