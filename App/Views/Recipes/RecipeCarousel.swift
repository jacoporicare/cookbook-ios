//
//  RecipeCarousel.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 22.11.2022.
//

import CachedAsyncImage
import SwiftUI

struct RecipeCarousel: View {
    var recipes: [Recipe]
    var height: CGFloat
    var spacing = 8.0

    var body: some View {
        GeometryReader { proxy in
            HStack(alignment: .center, spacing: spacing) {
                ForEach(recipes) { recipe in
                    if let imageUrl = recipe.gridImageUrl {
                        CachedAsyncImage(url: URL(string: imageUrl), urlCache: .imageCache) { phase in
                            switch phase {
                            case .success(let image):
                                GeometryReader { proxy in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: proxy.size.width, height: proxy.size.height)
                                        .clipped()
                                        .overlay {
                                            TextOverlay(recipe: recipe)
                                        }
                                        .cornerRadius(8)
                                }
                            case .failure:
                                Image(systemName: "fork.knife.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.black)
                                    .padding()
                            default:
                                ProgressView()
                            }
                        }
                        .frame(width: proxy.size.width, height: height)
                    }
                }
            }
            .modifier(ScrollingHStackModifier(
                items: recipes.count,
                itemWidth: proxy.size.width,
                itemSpacing: spacing
            ))
        }
    }
}

#if DEBUG
struct RecipeCarousel_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCarousel(recipes: recipePreviewData.filter { $0.gridImageUrl != nil }.map { Recipe(from: $0.fragments.recipeDetails) }, height: 300)
            .padding(.horizontal, 50)
    }
}
#endif
