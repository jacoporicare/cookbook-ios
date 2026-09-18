//
//  RecipeFormScreen.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 11.04.2022.
//

import CachedAsyncImage
import SwiftUI

/// Create (`recipe == nil`) and edit in one screen. All of the form state is plain
/// `@State` - there is no separate view model, because none of it outlives the view.
struct RecipeFormScreen: View {
    let recipe: Recipe?
    var isSousVideNewRecipe = false

    let onSave: (Recipe) -> Void
    let onCancel: () -> Void
    var onDelete: (() -> Void)?

    @Environment(RecipeStore.self) private var recipeStore
    @Environment(\.imageUploader) private var imageUploader

    @State private var draft: RecipeDraft
    @State private var inputImage: UIImage?
    @State private var isBusy = false
    @State private var isError = false

    @State private var ingredientEditMode = EditMode.inactive
    @State private var isImagePickerPresented = false
    @State private var isDeleteConfirmationPresented = false
    @State private var isCancelConfirmationPresented = false

    init(
        recipe: Recipe? = nil,
        isSousVideNewRecipe: Bool = false,
        onSave: @escaping (Recipe) -> Void,
        onCancel: @escaping () -> Void,
        onDelete: (() -> Void)? = nil
    ) {
        self.recipe = recipe
        self.isSousVideNewRecipe = isSousVideNewRecipe
        self.onSave = onSave
        self.onCancel = onCancel
        self.onDelete = onDelete

        _draft = State(
            initialValue: recipe.map { RecipeDraft(from: $0) }
                ?? .empty(isForSousVide: isSousVideNewRecipe)
        )
    }

    private var originalDraft: RecipeDraft {
        recipe.map { RecipeDraft(from: $0) } ?? .empty(isForSousVide: isSousVideNewRecipe)
    }

    private var isDirty: Bool {
        draft != originalDraft || inputImage != nil
    }

    var body: some View {
        List {
            imageSection
            basicInfoSection
            ingredientsSection
            directionsSection

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
        .environment(\.editMode, $ingredientEditMode)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Uložit", action: save)
                    .disabled(!draft.isValid)
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
        .disabled(isBusy) // Must be after .toolbar to disable those buttons
        .interactiveDismissDisabled(isDirty)
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $inputImage)
        }
        .alert("Nastala chyba.", isPresented: $isError) {}
        .confirmationDialog("Opravdu smazat recept?", isPresented: $isDeleteConfirmationPresented) {
            Button("Smazat recept", role: .destructive, action: delete)
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
            if isBusy {
                ZStack {
                    Color("ProgressOverlayColor")
                    ProgressView()
                }
            }
        }
    }

    // MARK: - Sections

    @ViewBuilder
    private var imageSection: some View {
        if let inputImage {
            Image(uiImage: inputImage)
                .centerCropped()
                .listRowInsets(EdgeInsets())
                .frame(height: 320)
                .onTapGesture {
                    isImagePickerPresented = true
                }
        } else if let imageUrl = recipe?.fullImageUrl {
            CachedAsyncImage(url: URL(string: imageUrl), urlCache: .imageCache) { image in
                image.centerCropped()
            } placeholder: {
                ProgressView()
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
                Text(inputImage == nil && recipe?.imageUrl == nil ? "Vybrat fotku" : "Změnit fotku")
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

    private var basicInfoSection: some View {
        Section("Základní informace") {
            labeledField("Název", text: $draft.title)

            labeledField("Doba přípravy (min)", text: $draft.preparationTime, keyboard: .numberPad)
                .onChange(of: draft.preparationTime) { _, newValue in
                    draft.preparationTime = newValue.filter(\.isNumber)
                }

            labeledField("Počet porcí", text: $draft.servingCount, keyboard: .numberPad)
                .onChange(of: draft.servingCount) { _, newValue in
                    draft.servingCount = newValue.filter(\.isNumber)
                }

            labeledField("Příloha", text: $draft.sideDish, autocapitalize: false)

            HStack {
                Text("Sous-vide recept")
                Spacer()
                Toggle("Sous-vide recept", isOn: $draft.isForSousVide)
                    .labelsHidden()
            }
        }
    }

    private func labeledField(
        _ label: String,
        text: Binding<String>,
        keyboard: UIKeyboardType = .default,
        autocapitalize: Bool = true
    ) -> some View {
        HStack {
            Text(label)
            Spacer()
            TextField("nezadáno", text: text)
                .keyboardType(keyboard)
                .textInputAutocapitalization(autocapitalize ? .sentences : .never)
                .multilineTextAlignment(.trailing)
        }
    }

    private var ingredientsSection: some View {
        Section {
            ForEach($draft.ingredients) { $ingredient in
                ingredientRow($ingredient)
            }
            .onMove { source, destination in
                draft.ingredients.move(fromOffsets: source, toOffset: destination)
            }

            Button {
                draft.ingredients.append(.init())
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

    private func ingredientRow(_ ingredient: Binding<RecipeDraft.Ingredient>) -> some View {
        VStack {
            TextField("Název", text: ingredient.name)
                .textInputAutocapitalization(.never)
                .fontWeight(ingredient.wrappedValue.isGroup ? .bold : nil)
                .frame(height: 24)

            Divider()

            GeometryReader { geo in
                HStack(alignment: .center) {
                    if ingredient.wrappedValue.isGroup {
                        Text("Skupina")
                            .foregroundColor(.gray)
                        Spacer()
                    } else {
                        TextField("Množství", text: ingredient.amount)
                            .keyboardType(.decimalPad)
                            .frame(maxWidth: geo.size.width * 0.5)
                            .foregroundColor(ingredient.wrappedValue.hasValidAmount ? .none : .red)

                        Divider()

                        TextField("Jednotka", text: ingredient.amountUnit)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }
                }
            }
            .frame(height: 24)
        }
        .listRowBackground(ingredient.wrappedValue.isGroup ? Color("IngredientGroupBackground") : nil)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                draft.ingredients.removeAll { $0.id == ingredient.wrappedValue.id }
            } label: {
                Label("Smazat", systemImage: "trash")
            }

            Button {
                ingredient.wrappedValue.isGroup.toggle()
            } label: {
                Label("Skupina", systemImage: "folder")
            }
        }
    }

    private var directionsSection: some View {
        Section {
            TextField("Zde napište postup receptu.", text: $draft.directions, axis: .vertical)
                .lineLimit(3...)
        } header: {
            Text("Postup")
        } footer: {
            Text("Formátovat můžete pomocí [Markdown](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet).")
        }
    }

    // MARK: - Actions

    private func save() {
        Task {
            isBusy = true
            defer { isBusy = false }

            do {
                let imageId = try await uploadImageIfNeeded()

                let saved = if let recipe {
                    try await recipeStore.update(id: recipe.id, draft: draft, imageId: imageId)
                } else {
                    try await recipeStore.create(draft, imageId: imageId)
                }

                onSave(saved)
            } catch {
                isError = true
            }
        }
    }

    private func uploadImageIfNeeded() async throws -> String? {
        guard let inputImage else { return nil }
        return try await imageUploader.upload(inputImage)
    }

    private func delete() {
        guard let recipe else {
            onDelete?()
            return
        }

        Task {
            isBusy = true
            defer { isBusy = false }

            do {
                try await recipeStore.delete(id: recipe.id)
                onDelete?()
            } catch {
                isError = true
            }
        }
    }
}

#if DEBUG
#Preview("New") {
    NavigationStack {
        RecipeFormScreen(onSave: { _ in }, onCancel: {})
            .navigationTitle("Nový recept")
            .navigationBarTitleDisplayMode(.inline)
    }
    .previewStores()
}

#Preview("New sous-vide") {
    NavigationStack {
        RecipeFormScreen(isSousVideNewRecipe: true, onSave: { _ in }, onCancel: {})
            .navigationTitle("Nový recept")
            .navigationBarTitleDisplayMode(.inline)
    }
    .previewStores()
}

#Preview("Edit") {
    NavigationStack {
        RecipeFormScreen(recipe: previewRecipes[0], onSave: { _ in }, onCancel: {}, onDelete: {})
            .navigationTitle(previewRecipes[0].title)
            .navigationBarTitleDisplayMode(.inline)
    }
    .previewStores()
}
#endif
