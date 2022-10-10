//
//  RecipeDetailView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 08.04.2022.
//

import CachedAsyncImage
import MarkdownUI
import SwiftUI

struct RecipeDetailView: View {
    var recipe: Recipe
    
    @EnvironmentObject private var currentUserStore: CurrentUserStore
    @Environment(\.editMode) private var editMode
    
    @State private var isIdleTimerDisabled = UIApplication.shared.isIdleTimerDisabled
    
    var body: some View {
        ScrollView {
            VStack {
                if let imageUrl = recipe.fullImageUrl {
                    CachedAsyncImage(url: URL(string: imageUrl), urlCache: .imageCache) { image in
                        image.centerCropped()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 320)
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Spacer()
                        Button {
                            isIdleTimerDisabled.toggle()
                            UIApplication.shared.isIdleTimerDisabled = isIdleTimerDisabled
                        } label: {
                            Label("Nezhasínat displej", systemImage: isIdleTimerDisabled ? "sun.max.fill" : "sun.max")
                        }
                        Spacer()
                    }
                    
                    basicInfo
                    ingredients
                    directions
                }
                .padding(.vertical)
            }
        }
        .toolbar {
            if currentUserStore.isLoggedIn {
                Button("Upravit") {
                    editMode?.animation().wrappedValue = .active
                }
            }
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
    
    @ViewBuilder
    var basicInfo: some View {
        if recipe.preparationTime != nil || recipe.servingCount != nil {
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    if let preparationTime = recipe.preparationTime {
                        HStack {
                            Text("Doba přípravy:")
                                .foregroundColor(.gray)
                            Text(preparationTime)
                        }
                    }
                    
                    if let servingCount = recipe.servingCount {
                        HStack {
                            Text("Počet porcí:")
                                .foregroundColor(.gray)
                            Text(servingCount)
                        }
                    }
                    
                    if let sideDish = recipe.sideDish {
                        HStack {
                            Text("Příloha:")
                                .foregroundColor(.gray)
                            Text(sideDish)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
                .font(.callout)
            }
        }
    }
    
    @ViewBuilder
    var ingredients: some View {
        if recipe.ingredients.count > 0 {
            VStack(alignment: .leading, spacing: 20) {
                Text("Ingredience")
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(recipe.ingredients) { ingredient in
                        if ingredient.isGroup {
                            Text(ingredient.name)
                                .bold()
                        } else {
                            VStack(alignment: .leading) {
                                Text(ingredient.name)
                                
                                if ingredient.amount != nil || ingredient.amountUnit != nil {
                                    HStack {
                                        if let amount = ingredient.amount {
                                            Text(amount)
                                        }
                                        if let amountUnit = ingredient.amountUnit {
                                            Text(amountUnit)
                                        }
                                    }
                                    .font(.callout)
                                    .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        Divider()
                    }
                }
                .padding(.horizontal)
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    var directions: some View {
        VStack(alignment: .leading) {
            Text("Postup")
                .font(.title2)
            
            Markdown(recipe.directions ?? "Kde nic tu nic.")
        }
        .padding(.horizontal)
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailView(recipe: Recipe(from: recipePreviewData[0]))
            .environmentObject(CurrentUserStore())
    }
}
