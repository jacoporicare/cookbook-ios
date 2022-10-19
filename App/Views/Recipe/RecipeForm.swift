//
//  RecipeForm.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 11.04.2022.
//

import CachedAsyncImage
import SwiftUI

struct RecipeForm: View {
    var recipe: Recipe? = nil
    var onSave: (Recipe) -> Void
    var onCancel: () -> Void
    var onDelete: (() -> Void)? = nil

    @StateObject private var viewModel = ViewModel()
    @State private var ingredientEditMode = EditMode.inactive
    @State private var isImagePickerPresented = false
    @State private var isDeleteConfirmationPresented = false
    @State private var isCancelConfirmationPresented = false

    var body: some View {
        List {
            image
            basicInfo
            ingredients
            directions

            if recipe != nil {
                Button {
                    isDeleteConfirmationPresented = true
                } label: {
                    Text("Smazat recept")
                    Spacer()
                }
                .foregroundColor(.red)
            }
        }
        .environment(\.editMode, $ingredientEditMode)
        .onAppear {
            viewModel.onSave = onSave
            viewModel.onDelete = onDelete

            guard let recipe else { return }
            viewModel.recipe = recipe
            viewModel.draftRecipe = RecipeEdit(from: recipe)
        }
        .buttonStyle(.borderless) // Fix non-clickable buttons in Form (and centers text in List)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Uložit", action: viewModel.save)
                    .disabled(!viewModel.isValid)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Zrušit") {
                    if viewModel.isDirty {
                        isCancelConfirmationPresented = true
                    } else {
                        onCancel()
                    }
                }
            }
        }
        .disabled(viewModel.isSaving) // Must be after .toolbar to disable those buttons
        .interactiveDismissDisabled(viewModel.isDirty)
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $viewModel.inputImage)
        }
        .alert("Nastala chyba.", isPresented: $viewModel.isError) {}
        .confirmationDialog("Opravdu smazat recept?", isPresented: $isDeleteConfirmationPresented) {
            Button("Smazat recept", role: .destructive, action: viewModel.delete)
            Button("Zrušit", role: .cancel) {}
        }
        .confirmationDialog(
            recipe == nil ? "Opravdu zahodit nový recept?" : "Opravdu zahodit změny?",
            isPresented: $isCancelConfirmationPresented,
            titleVisibility: .visible
        ) {
            Button("Zahodit změny", role: .destructive, action: onCancel)
            Button("Pokračovat v úpravách", role: .cancel) {}
        }
        .overlay {
            Group {
                if viewModel.isSaving {
                    ZStack {
                        Color("ProgressOverlayColor")
                        ProgressView()
                    }
                }
            }
        }
    }

    @ViewBuilder
    var image: some View {
        if let inputImage = viewModel.inputImage {
            Image(uiImage: inputImage)
                .centerCropped()
                .listRowInsets(EdgeInsets())
                .frame(height: 320)
                .onTapGesture {
                    isImagePickerPresented = true
                }
        } else if let imageUrl = recipe?.fullImageUrl {
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
                isImagePickerPresented = true
            }
        }

        HStack {
            Button {
                isImagePickerPresented = true
            } label: {
                Spacer()
                Text(viewModel.inputImage == nil && recipe?.gridImageUrl == nil ? "Vybrat fotku" : "Změnit fotku")
                Spacer()
            }

            if viewModel.inputImage != nil {
                Divider()

                Button(role: .destructive) {
                    viewModel.inputImage = nil
                } label: {
                    Spacer()
                    Text("Zrušit změnu")
                    Spacer()
                }
            }
        }
    }

    var basicInfo: some View {
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
    }

    @ViewBuilder
    var ingredients: some View {
        Section {
            ForEach($viewModel.draftRecipe.ingredients) { $ingredient in
                VStack {
                    TextField("Název", text: $ingredient.name)
                        .textInputAutocapitalization(.never)
                        .fontWeight($ingredient.isGroup.wrappedValue ? .bold : nil)
                        .frame(height: 24)

                    Divider()

                    GeometryReader { geo in
                        HStack(alignment: .center) {
                            if !$ingredient.isGroup.wrappedValue {
                                TextField("Množství", text: $ingredient.amount)
                                    .keyboardType(.decimalPad)
                                    .frame(maxWidth: geo.size.width * 0.5)
                                    .foregroundColor(Double($ingredient.amount.wrappedValue.replacingOccurrences(of: ",", with: ".")) == nil ? .red : .none)

                                Divider()

                                TextField("Jednotka", text: $ingredient.amountUnit)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                            } else {
                                Text("Skupina")
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                        }
                    }
                    .frame(height: 24)
                }
                .listRowBackground($ingredient.isGroup.wrappedValue ? Color("IngredientGroupBackground") : nil)
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        viewModel.draftRecipe.ingredients = viewModel.draftRecipe.ingredients.filter { $0.id != $ingredient.id }
                    } label: {
                        Label("Smazat", systemImage: "trash")
                    }

                    Button {
                        $ingredient.isGroup.wrappedValue.toggle()
                    } label: {
                        Label("Skupina", systemImage: "folder")
                    }
                }
            }
            .onMove { source, destination in
                viewModel.draftRecipe.ingredients.move(fromOffsets: source, toOffset: destination)
            }

            Button {
                viewModel.draftRecipe.ingredients.append(.init(name: "", isGroup: false, amount: "", amountUnit: ""))
            } label: {
                Text("Přidat ingredienci")
                Spacer()
            }
        } header: {
            HStack {
                Text("Ingredience")

                Spacer()

                Button {
                    withAnimation {
                        ingredientEditMode = ingredientEditMode == .inactive ? .active : .inactive
                    }
                } label: {
                    Text(ingredientEditMode == .inactive ? "Řadit" : "Hotovo")
                        .font(.footnote)
                }
            }
        }
    }

    @ViewBuilder
    var directions: some View {
        Section {
            TextField("Zde napište postup receptu.", text: $viewModel.draftRecipe.directions, axis: .vertical)
                .lineLimit(3...)
        } header: {
            Text("Postup")
        } footer: {
            Text("Formátovat můžete pomocí [Markdown](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet).")
        }
    }
}

#if DEBUG
struct RecipeForm_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RecipeForm(recipe: Recipe(from: recipePreviewData[1])) { _ in } onCancel: {}
            RecipeForm { _ in } onCancel: {}
        }
    }
}
#endif
