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

    let height = 300.0
    let trailingSpace = 48.0
    let spacing = 16.0

    @GestureState private var gestureOffset = 0.0
    @State private var currentIndex = 0

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width - trailingSpace + spacing
            let adjustmentModifier: CGFloat = currentIndex == 0
                ? 0
                : (currentIndex == recipes.count - 1
                    ? 2
                    : 1)
            let adjustment = ((trailingSpace / 2) - spacing) * adjustmentModifier
            let contentWidth = CGFloat(recipes.count) * width + spacing

            HStack(spacing: spacing) {
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
                        .frame(width: proxy.size.width - trailingSpace)
                    }
                }
            }
            .frame(height: height, alignment: .leading)
            .padding(.horizontal, spacing)
            .offset(x:
                max(
                    min(
                        (CGFloat(currentIndex) * -width) + adjustment + gestureOffset,
                        100.0
                    ),
                    -contentWidth + proxy.size.width - 100.0
                )
            )
            .gesture(
                DragGesture()
                    .updating($gestureOffset) { currentState, gestureState, _ in
                        gestureState = currentState.translation.width
                    }
                    .onEnded { state in
                        let offsetX = state.translation.width
                        let progress = -offsetX / width
                        let roundedIndex = progress.rounded()

                        currentIndex = max(min(currentIndex + Int(roundedIndex), recipes.count - 1), 0)
                    }
            )
        }
        .animation(.easeOut, value: gestureOffset == 0)
    }
}

#if DEBUG
struct RecipeCarousel_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCarousel(recipes: recipePreviewData.filter { $0.fullImageUrl != nil }.map { Recipe(from: $0.fragments.recipeDetails) })
    }
}
#endif
