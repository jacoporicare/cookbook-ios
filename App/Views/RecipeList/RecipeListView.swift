//
//  RecipeListView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 24.09.2022.
//

import CachedAsyncImage
import SwiftUI

struct RecipeListView: View {
    let recipeGroups: [RecipeGroup]

    @Environment(RecipeStore.self) private var recipeStore

    var body: some View {
        List(recipeGroups) { recipeGroup in
            Section(header: Text(recipeGroup.id)) {
                ForEach(recipeGroup.recipes) { recipe in
                    NavigationLink(value: RecipeRoute(recipeId: recipe.id)) {
                        RecipeListRow(recipe: recipe)
                    }
                }
            }
            .id(recipeGroup.id)
        }
        .listStyle(.insetGrouped)
        .refreshable {
            await recipeStore.refresh()
        }
    }
}

struct RecipeListRow: View {
    let recipe: Recipe

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

    private var placeholder: some View {
        Image(systemName: "fork.knife.circle")
            .resizable()
            .scaledToFit()
            .symbolRenderingMode(.hierarchical)
    }
}

#if DEBUG
#Preview("List") {
    NavigationStack {
        RecipeListView(recipeGroups: previewRecipes.groupedByFirstLetter())
    }
    .previewStores()
}

#Preview("Row") {
    List {
        ForEach(previewRecipes) { recipe in
            RecipeListRow(recipe: recipe)
        }
    }
}
#endif
