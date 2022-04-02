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
            if let imageUrl = recipe.fullImageUrl {
                AsyncImage(url: URL(string: imageUrl)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        ProgressView()
                    }
                }
                .frame(height: 300)
                .frame(maxWidth: .infinity)
                .clipped()
            } else {
                Image("placeholder")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
                    .clipped()
            }
            Text(recipe.title)
                .font(.title)
                .padding(10)
            
        }
        .background(.background)
        .cornerRadius(8)
        .shadow(radius: 8)
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
