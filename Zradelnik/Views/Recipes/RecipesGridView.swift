//
//  RecipesGridView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 24.09.2022.
//

import CachedAsyncImage
import SwiftUI

private let alphabet = ["#", "A", "Á", "B", "C", "Č", "D", "Ď", "E", "É", "F", "G", "H", "CH", "I", "Í", "J", "K", "L", "M", "N", "O", "Ó", "P", "Q", "R", "Ř", "S", "Š", "T", "Ť", "U", "Ú", "V", "W", "X", "Y", "Ý", "Z", "Ž"]

struct RecipesGridView: View {
    var recipes: [Recipe]
    var searchText: Binding<String>

    private var recipeGroups: [RecipeGroup]
    private var letters: [String]

    private let columnLayout = Array(repeating: GridItem(), count: 2)

    init(recipes: [Recipe], searchText: Binding<String>) {
        self.recipes = recipes
        self.searchText = searchText

        let dict = Dictionary(grouping: recipes) { recipe in
            alphabet.contains(String(recipe.title.uppercased().prefix(2)))
                ? String(recipe.title.uppercased().prefix(2))
                : alphabet.contains(String(recipe.title.uppercased().prefix(1)))
                ? String(recipe.title.uppercased().prefix(1))
                : "#"
        }

        self.recipeGroups = dict
            .map { key, value in
                RecipeGroup(id: key, recipes: value)
            }
            .sorted { $0.id.compare($1.id, locale: zradelnikLocale) == .orderedAscending }

        self.letters = dict.keys.sorted { $0.compare($1, locale: zradelnikLocale) == .orderedAscending }
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVGrid(columns: columnLayout) {
                    ForEach(recipeGroups) { recipeGroup in
                        Section {
                            ForEach(recipeGroup.recipes) { recipe in
                                NavigationLink {
                                    RecipeView(recipe: recipe)
                                } label: {
                                    RecipesGridItemView(recipe: recipe)
                                }
                            }
                        } header: {
                            HStack {
                                Text(recipeGroup.id)
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                            .padding(.top)
                        }
                    }
                }
                .padding()
            }
            .searchable(text: searchText, prompt: "Hledat recept")
//            .overlay {
//                SectionLettersView(letters: letters, scrollViewProxy: proxy)
//                    .frame(maxWidth: .infinity, alignment: .trailing)
//                    .padding(.trailing, 10)
//            }
        }
    }
}

struct SectionLettersView: View {
    var letters: [String]
    var scrollViewProxy: ScrollViewProxy

    @GestureState private var dragLocation: CGPoint = .zero

    var body: some View {
        VStack(spacing: 2) {
            ForEach(letters, id: \.self) { letter in
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

    private func dragObserver(letter: String) -> some View {
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

struct RecipesGridItemView: View {
    var recipe: Recipe

    var body: some View {
        VStack(spacing: 0) {
            if let imageUrl = recipe.gridImageUrl {
                CachedAsyncImage(url: URL(string: imageUrl), urlCache: .imageCache) { phase in
                    switch phase {
                    case .success(let image):
                        GeometryReader { geo in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: geo.size.width, height: geo.size.height)
                        }
                    case .failure:
                        placeholder
                    default:
                        ProgressView()
                    }
                }
                .modifier(ImageModifier(recipe: recipe))
            } else {
                placeholder
            }
        }
        .background(.background)
        .cornerRadius(8)
        .shadow(radius: 8)
    }

    var placeholder: some View {
        Image("placeholder")
            .resizable()
            .scaledToFit()
            .modifier(ImageModifier(recipe: recipe))
            .background(Color(.lightGray))
    }

    struct ImageModifier: ViewModifier {
        let recipe: Recipe

        func body(content: Content) -> some View {
            content
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .clipped()
                .overlay {
                    TextOverlay(recipe: recipe)
                }
        }
    }
}

struct TextOverlay: View {
    var recipe: Recipe

    var gradient: LinearGradient {
        .linearGradient(
            Gradient(colors: [.black.opacity(0.6), .black.opacity(0)]),
            startPoint: .bottom,
            endPoint: .center
        )
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            gradient
            VStack(alignment: .leading) {
                Text(recipe.title)
                    .font(.title3)
                    .bold()
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
            }
            .padding()
        }
        .foregroundColor(.white)
    }
}

#if DEBUG
struct RecipesGridItemView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            RecipesGridItemView(recipe: Recipe(from: recipePreviewData[4]))
            RecipesGridItemView(recipe: Recipe(from: recipePreviewData[2]))
        }
        .padding()
    }
}
#endif
