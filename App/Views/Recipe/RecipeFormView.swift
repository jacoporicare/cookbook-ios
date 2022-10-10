//
//  RecipeFormView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 11.04.2022.
//

import Apollo
import CachedAsyncImage
import SwiftUI

struct RecipeFormView: View {
    var recipe: Recipe? = nil
    var onSave: (Recipe) -> Void
    var onCancel: () -> Void
    var onDelete: (() -> Void)? = nil

    @State private var draftRecipe = RecipeEdit.default
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var saving = false
    @State private var error = false
    @State private var showingDeleteConfirmation = false
    @State private var showingCancelConfirmation = false

    private var isValid: Bool {
        !draftRecipe.title.isEmpty && !draftRecipe.ingredients.contains(where: { ingredient in
            !ingredient.amount.isEmpty && Double(ingredient.amount.replacingOccurrences(of: ",", with: ".")) == nil
        })
    }

    private var isDirty: Bool {
        (recipe == nil && draftRecipe != RecipeEdit.default)
            || (recipe != nil && draftRecipe != RecipeEdit(from: recipe!))
            || inputImage != nil
    }

    var body: some View {
        Form {
            image
            basicInfo
            ingredients
            directions

            if recipe != nil {
                Button {
                    showingDeleteConfirmation = true
                } label: {
                    Text("Smazat recept")
                    Spacer()
                }
                .foregroundColor(.red)
            }
        }
        .onAppear {
            guard let recipe else { return }
            draftRecipe = RecipeEdit(from: recipe)
        }
        .buttonStyle(.borderless) // Fix non-clickable buttons in Form
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Uložit", action: save)
                    .disabled(!isValid)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Zrušit") {
                    if isDirty {
                        showingCancelConfirmation = true
                    } else {
                        onCancel()
                    }
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
        .disabled(saving)
        .interactiveDismissDisabled(isDirty)
        .alert("Nastala chyba.", isPresented: $error) {}
        .confirmationDialog("Opravdu smazat recept?", isPresented: $showingDeleteConfirmation) {
            Button("Smazat recept", role: .destructive, action: delete)
            Button("Zrušit", role: .cancel, action: {})
        }
        .confirmationDialog(
            recipe == nil ? "Opravdu zahodit nový recept?" : "Opravdu zahodit změny?",
            isPresented: $showingCancelConfirmation,
            titleVisibility: .visible
        ) {
            Button("Zahodit změny", role: .destructive, action: onCancel)
            Button("Pokračovat v úpravách", role: .cancel) {}
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
                    showingImagePicker = true
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
                showingImagePicker = true
            }
        }

        HStack {
            Button {
                showingImagePicker = true
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
            List {
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
                .onDelete { offsets in
                    draftRecipe.ingredients.remove(atOffsets: offsets)
                }
            }

            Button {
                draftRecipe.ingredients.append(.init(name: "", isGroup: false, amount: "", amountUnit: ""))
            } label: {
                Text("Přidat ingredienci")
                Spacer()
            }
        } header: {
            Text("Ingredience")
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

    func save() {
        saving = true

        var files: [GraphQLFile] = []
        if let data = inputImage?.jpegData(compressionQuality: 100) {
            files.append(.init(fieldName: "image", originalName: "image", data: data))
        }

        if let recipe {
            let mutation = UpdateRecipeMutation(
                id: recipe.id,
                recipe: draftRecipe.toRecipeInput(),
                image: inputImage != nil ? "image" : nil
            )

            Network.shared.apollo.upload(operation: mutation, files: files) { result in
                self.saving = false

                switch result {
                case .success(let result):
                    guard let recipe = result.data?.updateRecipe else { fallthrough }
                    onSave(Recipe(from: recipe.fragments.recipeDetails))
                case .failure:
                    self.error = true
                }
            }
        } else {
            let mutation = CreateRecipeMutation(
                recipe: draftRecipe.toRecipeInput(),
                image: inputImage != nil ? "image" : nil
            )

            Network.shared.apollo.upload(operation: mutation, files: files) { result in
                self.saving = false

                switch result {
                case .success(let result):
                    guard let recipe = result.data?.createRecipe else { fallthrough }
                    onSave(Recipe(from: recipe.fragments.recipeDetails))
                case .failure:
                    self.error = true
                }
            }
        }
    }

    func delete() {
        guard let recipe else { return }

        saving = true

        let mutation = DeleteRecipeMutation(id: recipe.id)

        Network.shared.apollo.perform(mutation: mutation) { result in
            self.saving = false

            switch result {
            case .success(let result):
                guard let _ = result.data?.deleteRecipe else { fallthrough }
                onDelete?()
            case .failure:
                self.error = true
            }
        }
    }
}

#if DEBUG
struct RecipeForm_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RecipeFormView(recipe: Recipe(from: recipePreviewData[1])) { _ in } onCancel: {}
            RecipeFormView { _ in } onCancel: {}
        }
    }
}
#endif
