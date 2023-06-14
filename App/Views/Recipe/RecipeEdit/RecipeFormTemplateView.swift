//
//  RecipeFormTemplateView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 14.06.2023.
//

import CachedAsyncImage
import SwiftUI

struct RecipeFormTemplateView: View {
    @Binding var draftRecipe: RecipeEdit
    @Binding var inputImage: UIImage?
    @Binding var isImagePickerPresented: Bool
    @Binding var ingredientEditMode: EditMode
    @Binding var isDeleteConfirmationPresented: Bool
    @Binding var isCancelConfirmationPresented: Bool
    @Binding var isError: Bool

    let recipe: Recipe?
    let isValid: Bool
    let isDirty: Bool
    let isSaving: Bool

    let onSave: Callback
    let onCancel: Callback
    let onDelete: Callback?

    @ViewBuilder
    var image: some View {
        if let inputImage = inputImage {
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
                Text(inputImage == nil && recipe?.gridImageUrl == nil ? "Vybrat fotku" : "Změnit fotku")
                Spacer()
            }

            if inputImage != nil {
                Divider()

                Button(role: .destructive) {
                    inputImage = nil
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
                TextField("nezadáno", text: $draftRecipe.title)
                    .multilineTextAlignment(.trailing)
            }

            HStack {
                Text("Doba přípravy (min)")
                Spacer()
                TextField("nezadáno", text: $draftRecipe.preparationTime)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .onChange(of: draftRecipe.preparationTime) { newValue in
                        if !newValue.isEmpty, Int(newValue) == nil {
                            draftRecipe.preparationTime = newValue.filter { $0.isNumber }
                        }
                    }
            }

            HStack {
                Text("Počet porcí")
                Spacer()
                TextField("nezadáno", text: $draftRecipe.servingCount)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .onChange(of: draftRecipe.servingCount) { newValue in
                        if !newValue.isEmpty, Int(newValue) == nil {
                            draftRecipe.servingCount = newValue.filter { $0.isNumber }
                        }
                    }
            }

            HStack {
                Text("Příloha")
                Spacer()
                TextField("nezadáno", text: $draftRecipe.sideDish)
                    .textInputAutocapitalization(.never)
                    .multilineTextAlignment(.trailing)
            }

            HStack {
                Text("Instant Pot recept")
                Spacer()
                Toggle("Instant Pot recept", isOn: $draftRecipe.isForInstantPot)
                    .labelsHidden()
            }
        }
    }

    @ViewBuilder
    var ingredients: some View {
        Section {
            ForEach($draftRecipe.ingredients) { $ingredient in
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
                        draftRecipe.ingredients = draftRecipe.ingredients.filter { $0.id != $ingredient.id }
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
                draftRecipe.ingredients.move(fromOffsets: source, toOffset: destination)
            }

            Button {
                draftRecipe.ingredients.append(.init(name: "", isGroup: false, amount: "", amountUnit: ""))
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
            TextField("Zde napište postup receptu.", text: $draftRecipe.directions, axis: .vertical)
                .lineLimit(3...)
        } header: {
            Text("Postup")
        } footer: {
            Text("Formátovat můžete pomocí [Markdown](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet).")
        }
    }

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
        .buttonStyle(.borderless) // Fix non-clickable buttons in Form (and centers text in List)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Uložit", action: onSave)
                    .disabled(!isValid)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Zrušit") {
                    if isDirty {
                        isCancelConfirmationPresented = true
                    } else {
                        onCancel()
                    }
                }
            }
        }
        .disabled(isSaving) // Must be after .toolbar to disable those buttons
        .interactiveDismissDisabled(isDirty)
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $inputImage)
        }
        .alert("Nastala chyba.", isPresented: $isError) {}
        .confirmationDialog("Opravdu smazat recept?", isPresented: $isDeleteConfirmationPresented) {
            Button("Smazat recept", role: .destructive, action: onDelete ?? {})
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
                if isSaving {
                    ZStack {
                        Color("ProgressOverlayColor")
                        ProgressView()
                    }
                }
            }
        }
    }
}

// #if DEBUG
// struct RecipeForm_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            RecipeFormScreenView(recipe: Recipe(from: recipePreviewData[1].fragments.recipeDetails)) { _ in } onCancel: {}
//            RecipeFormScreenView { _ in } onCancel: {}
//        }
//    }
// }
// #endif
