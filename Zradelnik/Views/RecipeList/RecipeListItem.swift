//
//  RecipeListItem.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import CachedAsyncImage
import SwiftUI

struct RecipeListItem: View {
    var recipe: Recipe
    
    var body: some View {
        VStack(spacing: 0) {
            if let imageUrl = recipe.imageUrl {
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
struct RecipeListItem_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            RecipeListItem(recipe: Recipe(from: recipePreviewData[4]))
            RecipeListItem(recipe: Recipe(from: recipePreviewData[2]))
        }
        .padding()
    }
}
#endif
