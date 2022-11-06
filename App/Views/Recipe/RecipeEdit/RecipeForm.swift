//
//  RecipeForm.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 11.04.2022.
//

import CachedAsyncImage
import SwiftUI

struct RecipeForm: View {
    let recipe: Recipe?
    let onSave: (Recipe) -> Void
    let onCancel: () -> Void
    let onDelete: (() -> Void)?

    init(
        recipe: Recipe? = nil,
        onSave: @escaping (Recipe) -> Void,
        onCancel: @escaping () -> Void,
        onDelete: (() -> Void)? = nil
    ) {
        self.recipe = recipe
        self.onSave = onSave
        self.onCancel = onCancel
        self.onDelete = onDelete

        if let recipe {
            _draftRecipe = .init(wrappedValue: RecipeEdit(from: recipe))
        }
    }

    @StateObject private var vm = ViewModel()

    @State private var draftRecipe = RecipeEdit.default
    @State private var inputImage: UIImage?
    @State private var ingredientEditMode = EditMode.inactive
    @State private var isImagePickerPresented = false
    @State private var isDeleteConfirmationPresented = false
    @State private var isCancelConfirmationPresented = false

    var isValid: Bool {
        !draftRecipe.title.isEmpty && !draftRecipe.ingredients.contains { ingredient in
            !ingredient.amount.isEmpty && Double(ingredient.amount.replacingOccurrences(of: ",", with: ".")) == nil
        }
    }

    var isDirty: Bool {
        (recipe == nil && draftRecipe != RecipeEdit.default)
            || (recipe != nil && draftRecipe != RecipeEdit(from: recipe!))
            || inputImage != nil
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
        .environment(\.editMode, $ingredientEditMode)
        .buttonStyle(.borderless) // Fix non-clickable buttons in Form (and centers text in List)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Uložit") {
                    vm.save(
                        id: recipe?.id,
                        data: draftRecipe,
                        image: inputImage,
                        completionHandler: onSave
                    )
                }
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
        .disabled(vm.isSaving) // Must be after .toolbar to disable those buttons
        .interactiveDismissDisabled(isDirty)
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $inputImage)
        }
        .alert("Nastala chyba.", isPresented: $vm.isError) {}
        .confirmationDialog("Opravdu smazat recept?", isPresented: $isDeleteConfirmationPresented) {
            Button("Smazat recept", role: .destructive) {
                guard let id = recipe?.id else { return }
                vm.delete(id: id, completionHandler: onDelete ?? {})
            }
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
                if vm.isSaving {
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
        if let inputImage {
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
}

#if DEBUG
struct RecipeForm_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RecipeForm(recipe: Recipe(from: recipePreviewData[1].fragments.recipeDetails)) { _ in } onCancel: {}
            RecipeForm { _ in } onCancel: {}
        }
    }
}
#endif
