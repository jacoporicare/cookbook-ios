//
//  RecipesListView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 24.09.2022.
//

import CachedAsyncImage
import SwiftUI

private let alphabet = ["#", "A", "Á", "B", "C", "Č", "D", "Ď", "E", "É", "F", "G", "H", "CH", "I", "Í", "J", "K", "L", "M", "N", "O", "Ó", "P", "Q", "R", "Ř", "S", "Š", "T", "Ť", "U", "Ú", "V", "W", "X", "Y", "Ý", "Z", "Ž"]

struct RecipeGroup: Identifiable {
    let id: String
    let recipes: [Recipe]
}

struct RecipesListView: View {
    @EnvironmentObject private var model: Model

    var recipes: [Recipe]
    var searchText: Binding<String>

    private var recipeGroups: [RecipeGroup]

    init(recipes: [Recipe], searchText: Binding<String>) {
        self.recipes = recipes
        self.searchText = searchText

        self.recipeGroups = Dictionary(grouping: recipes) { recipe in
            alphabet.contains(String(recipe.title.uppercased().prefix(2)))
                ? String(recipe.title.uppercased().prefix(2))
                : alphabet.contains(String(recipe.title.uppercased().prefix(1)))
                ? String(recipe.title.uppercased().prefix(1))
                : "#"
        }
        .map { key, value in
            RecipeGroup(id: key, recipes: value)
        }
        .sorted { $0.id.compare($1.id, locale: zradelnikLocale) == .orderedAscending }
    }

    var body: some View {
        List(recipeGroups) { recipeGroup in
            Section(header: Text(recipeGroup.id)) {
                ForEach(recipeGroup.recipes) { recipe in
                    NavigationLink {
                        RecipeView(recipe: recipe)
                    } label: {
                        RecipesListItemView(recipe: recipe)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .searchable(text: searchText, prompt: "Hledat recept")
        .refreshable {
            try? await model.fetchRecipesAsync()
        }
    }
}

struct RecipesListItemView: View {
    var recipe: Recipe

    var body: some View {
        HStack(spacing: 16) {
            Group {
                if let imageUrl = recipe.listImageUrl {
                    CachedAsyncImage(url: URL(string: imageUrl), urlCache: .imageCache) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                        case .failure:
                            placeholder
                        default:
                            ProgressView()
                        }
                    }
                } else {
                    placeholder
                }
            }
            .frame(width: 80, height: 60)
            .cornerRadius(4)

            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.title)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)

                if let preparationTime = recipe.preparationTime {
                    Text(preparationTime)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    var placeholder: some View {
        Image(systemName: "fork.knife.circle")
            .resizable()
            .scaledToFit()
            .symbolRenderingMode(.hierarchical)
    }
}

#if DEBUG
struct RecipesListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesListView(
            recipes: recipePreviewData.map { Recipe(from: $0) },
            searchText: .constant("")
        )
    }
}

struct RecipesListItemView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            RecipesListItemView(recipe: Recipe(from: recipePreviewData[3]))
            RecipesListItemView(recipe: Recipe(from: recipePreviewData[114]))
        }
    }
}
#endif
