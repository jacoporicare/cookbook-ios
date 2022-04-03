//
//  RecipeListItem.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import SwiftUI

struct RecipeListItem: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(spacing: 0) {
            if let imageUrl = recipe.thumbImageUrl {
                AsyncImage(url: URL(string: imageUrl)) { phase in
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
            .background(.gray)
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
            }
            .padding()
        }
        .foregroundColor(.white)
    }
}

struct RecipeListItem_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RecipeListItem(recipe: recipePreviewData[4])
            RecipeListItem(recipe: recipePreviewData[2])
        }
        .padding()
    }
}
