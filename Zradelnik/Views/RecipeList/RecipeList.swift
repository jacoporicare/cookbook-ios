//
//  RecipeList.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import SwiftUI

struct RecipeList: View {
    @EnvironmentObject private var model: Model
    @State private var showingRecipeForm = false
    @State private var activeRecipeId: String?

    private let columnLayout = Array(repeating: GridItem(), count: 2)
    private let alphabet = ["#", "A", "Á", "B", "C", "Č", "D", "Ď", "E", "É", "F", "G", "H", "CH", "I", "Í", "J", "K", "L", "M", "N", "O", "Ó", "P", "Q", "R", "Ř", "S", "Š", "T", "Ť", "U", "Ú", "V", "W", "X", "Y", "Ý", "Z", "Ž"]

    private var groupedRecipes: [String: [Recipe]] {
        Dictionary(grouping: model.filteredRecipes, by: { recipe in
            alphabet.contains(String(recipe.title.uppercased().prefix(2)))
                ? String(recipe.title.uppercased().prefix(2))
                : alphabet.contains(String(recipe.title.uppercased().prefix(1)))
                ? String(recipe.title.uppercased().prefix(1))
                : "#"
        })
    }

    var body: some View {
        LoadingContent(status: model.loadingStatus) {
            loadedView()
        }
        .navigationTitle("Žrádelník")
        .toolbar {
            if model.isLoggedIn {
                Button {
                    showingRecipeForm = true
                } label: {
                    Label("Nový recept", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingRecipeForm) {
            NavigationView {
                RecipeForm { id in
                    model.refetchRecipes()
                    showingRecipeForm = false
                    activeRecipeId = id
                } onCancel: {
                    showingRecipeForm = false
                }
                .navigationTitle("Nový recept")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }

    func loadedView() -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVGrid(columns: columnLayout) {
                    ForEach(alphabet, id: \.self) { letter in
                        if let recipeGroup = groupedRecipes[letter] {
                            Section {
                                ForEach(recipeGroup) { recipe in
                                    NavigationLink(tag: recipe.id, selection: $activeRecipeId) {
                                        RecipeView(recipe: recipe)
                                    } label: {
                                        RecipeListItem(recipe: recipe)
                                    }
                                }
                            } header: {
                                HStack {
                                    Text(letter)
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                .padding(.top)
                            }
                        }
                    }
                }
                .padding()
                .padding(.trailing, 25)
            }
            .searchable(text: $model.searchText, prompt: "Hledat recept")
            .overlay {
                SectionLettersView(groupedRecipes: groupedRecipes, scrollViewProxy: proxy)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 10)
            }
        }
    }
}

struct SectionLettersView: View {
    var groupedRecipes: [String: [Recipe]]
    var scrollViewProxy: ScrollViewProxy

    @GestureState private var dragLocation: CGPoint = .zero

    private let locale = Locale(identifier: "cs")

    var body: some View {
        VStack(spacing: 2) {
            ForEach(groupedRecipes.keys.sorted { $0.compare($1, locale: locale) == .orderedAscending }, id: \.self) { letter in
                Text(letter)
                    .font(.caption)
                    .foregroundColor(.blue)
                    .background(dragObserver(letter: letter))
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .updating($dragLocation) { value, state, _ in
                    state = value.location
                }
        )
    }

    func dragObserver(letter: String) -> some View {
        GeometryReader { geometry in
            dragObserver(geometry: geometry, letter: letter)
        }
    }

    // This function is needed as view builders don't allow to have
    // pure logic in their body.
    private func dragObserver(geometry: GeometryProxy, letter: String) -> some View {
        if geometry.frame(in: .global).contains(dragLocation) {
            // we need to dispatch to the main queue because we cannot access to the
            // `ScrollViewProxy` instance while the body is rendering
            DispatchQueue.main.async {
                let feedbackGenerator = UISelectionFeedbackGenerator()
                feedbackGenerator.selectionChanged()

                scrollViewProxy.scrollTo(letter, anchor: .top)
            }
        }

        return Rectangle().fill(Color.clear)
    }
}

#if DEBUG
struct RecipeList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeList()
//                .loadedView(recipes: recipePreviewData.map { Recipe(from: $0) })
                .loadedView()
                .navigationTitle("Žrádelník")
        }
    }
}
#endif
