//
//  RecipeDetailTemplateView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 10.06.2023.
//

import CachedAsyncImage
import MarkdownUI
import SwiftUI

struct RecipeDetailTemplateView: View {
    @Binding var cookedDatePickerVisible: Bool
    
    let recipe: Recipe
    let isUserLoggedIn: Bool
    let isSaving: Bool
    
    let onRecipeCook: (Date) -> Void
    let onCookedRecipeDelete: (String) -> Void
    
    @Environment(\.editMode) private var editMode

    var body: some View {
        ScrollView {
            if let imageUrl = recipe.fullImageUrl {
                CachedAsyncImage(url: URL(string: imageUrl), urlCache: .imageCache) { image in
                    image.centerCropped()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 320)
            }
                
            VStack(alignment: .leading, spacing: 30) {
                RecipeDetailActionButtonsView(
                    cookedDatePickerVisible: $cookedDatePickerVisible,
                    isUserLoggedIn: isUserLoggedIn
                )
                    
                if cookedDatePickerVisible {
                    RecipeCookedDatePicker(confirmAction: onRecipeCook)
                }
                
                if recipe.isForInstantPot {
                    RecipeDetailInstantPotInfoView()
                }
                        
                if let cooked = recipe.cookedHistory.last {
                    RecipeDetailLastCookedDate(
                        cooked: cooked,
                        history: recipe.cookedHistory,
                        onRecipeCookedDelete: onCookedRecipeDelete
                    )
                }
                    
                if recipe.preparationTime != nil || recipe.servingCount != nil || recipe.sideDish != nil {
                    RecipeDetailBasicInfoView(
                        preparationTime: recipe.preparationTime,
                        servingCount: recipe.servingCount,
                        sideDish: recipe.sideDish
                    )
                }
                    
                if recipe.ingredients.count > 0 {
                    RecipeDetailIngredientsView(ingredients: recipe.ingredients)
                }
                        
                VStack(alignment: .leading) {
                    Text("Postup")
                        .font(.title2)
                            
                    Markdown(recipe.directions ?? "Kde nic tu nic.")
                }
            }
            .padding()
        }
        .navigationTitle(recipe.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if isUserLoggedIn {
                Button("Upravit") {
                    editMode?.animation().wrappedValue = .active
                }
            }
        }
        .disabled(isSaving)
        .overlay {
            Group {
                if isSaving {
                    ZStack {
                        Color("ProgressOverlayColor")
                        ProgressView()
                    }
                }
            }
        }
    }
}

struct RecipeDetailTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                RecipeDetailTemplateView(
                    cookedDatePickerVisible: .constant(false),
                    recipe: Recipe(from: recipePreviewData[2].fragments.recipeDetails),
                    isUserLoggedIn: false,
                    isSaving: false,
                    onRecipeCook: { _ in },
                    onCookedRecipeDelete: { _ in }
                )
            }
            
            NavigationStack {
                RecipeDetailTemplateView(
                    cookedDatePickerVisible: .constant(false),
                    recipe: Recipe(from: recipePreviewData[0].fragments.recipeDetails),
                    isUserLoggedIn: false,
                    isSaving: false,
                    onRecipeCook: { _ in },
                    onCookedRecipeDelete: { _ in }
                )
            }
            .previewDisplayName("Instant Pot")
            
            NavigationStack {
                RecipeDetailTemplateView(
                    cookedDatePickerVisible: .constant(false),
                    recipe: Recipe(from: recipePreviewData[0].fragments.recipeDetails),
                    isUserLoggedIn: true,
                    isSaving: false,
                    onRecipeCook: { _ in },
                    onCookedRecipeDelete: { _ in }
                )
            }
            .previewDisplayName("Logged In")
            
            NavigationStack {
                RecipeDetailTemplateView(
                    cookedDatePickerVisible: .constant(false),
                    recipe: Recipe(from: recipePreviewData[0].fragments.recipeDetails),
                    isUserLoggedIn: true,
                    isSaving: true,
                    onRecipeCook: { _ in },
                    onCookedRecipeDelete: { _ in }
                )
            }
            .previewDisplayName("Saving")
            
            NavigationStack {
                RecipeDetailTemplateView(
                    cookedDatePickerVisible: .constant(true),
                    recipe: Recipe(from: recipePreviewData[0].fragments.recipeDetails),
                    isUserLoggedIn: true,
                    isSaving: false,
                    onRecipeCook: { _ in },
                    onCookedRecipeDelete: { _ in }
                )
            }
            .previewDisplayName("Date Picker")
        }
    }
}
