//
//  RecipesList.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 24.09.2022.
//

import CachedAsyncImage
import SwiftUI

struct RecipesList: View {
    @EnvironmentObject private var recipeStore: RecipeStore

    var recipeGroups: [RecipeGroup]
    @Binding var searchText: String
    @Binding var shouldResetScrollPosition: Bool

    var body: some View {
        ScrollViewReader { proxy in
            List(recipeGroups) { recipeGroup in
                Section(header: Text(recipeGroup.id)) {
                    ForEach(recipeGroup.recipes) { recipe in
                        NavigationLink(value: recipe) {
                            RecipesListItemView(recipe: recipe)
                        }
                    }
                }
                .id(recipeGroup.id)
            }
            .listStyle(.insetGrouped)
            .searchable(text: $searchText, prompt: "Hledat recept")
            .refreshable {
                try? await recipeStore.loadAsync()
            }
            .onChange(of: shouldResetScrollPosition) { newValue in
                guard newValue else { return }
                withAnimation {
                    proxy.scrollTo(recipeGroups.first?.id)
                }
                shouldResetScrollPosition = false
            }
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
// struct RecipesListView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecipesList(
//            recipeGroups: recipePreviewData.map { Recipe(from: $0) },
//            searchText: .constant("")
//        )
//    }
// }

struct RecipesListItemView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ForEach(recipePreviewData, id: \.id) { recipe in
                RecipesListItemView(recipe: Recipe(from: recipe.fragments.recipeDetails))
            }
        }
    }
}
#endif
