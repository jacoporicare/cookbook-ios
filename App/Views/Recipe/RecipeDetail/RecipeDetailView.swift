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
    
    @EnvironmentObject private var routing: Routing
    @EnvironmentObject private var currentUserStore: CurrentUserStore
    @Environment(\.editMode) private var editMode
    
    @StateObject private var vm = ViewModel()
    
    @State private var cookedDatePickerVisible = false
    
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
                    isUserLoggedIn: currentUserStore.isLoggedIn,
                    cookedDatePickerVisible: $cookedDatePickerVisible
                )
                    
                if cookedDatePickerVisible {
                    RecipeCookedDatePicker(confirmAction: recipeCooked)
                }
                
                if recipe.isForInstantPot {
                    RecipeDetailInstantPotInfoView()
                }
                        
                if let cooked = recipe.cookedHistory.last {
                    RecipeDetailLastCookedDate(
                        cooked: cooked,
                        history: recipe.cookedHistory,
                        onRecipeCookedDelete: deleteRecipeCooked
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
        .toolbar {
            if currentUserStore.isLoggedIn {
                Button("Upravit") {
                    editMode?.animation().wrappedValue = .active
                }
            }
        }
        .disabled(vm.isSaving)
        .overlay {
            Group {
                if vm.isSaving {
                    ZStack {
                        Color("ProgressOverlayColor")
                        ProgressView()
                    }
                }
            }
        }
    }
   
    func recipeCooked(cookedDate: Date) {
        vm.recipeCooked(id: recipe.id, date: cookedDate) { newRecipe in
            withAnimation {
                cookedDatePickerVisible.toggle()
            }
            
            guard let newRecipe else { return }
            routing.recipeListStack[routing.recipeListStack.endIndex - 1] = newRecipe
        }
    }
    
    func deleteRecipeCooked(cookedId: String) {
        vm.deleteRecipeCooked(recipeId: recipe.id, cookedId: cookedId) { newRecipe in
            guard let newRecipe else { return }
            routing.recipeListStack[routing.recipeListStack.endIndex - 1] = newRecipe
        }
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                RecipeDetailView(recipe: Recipe(from: recipePreviewData[0].fragments.recipeDetails))
                    .navigationTitle(recipePreviewData[0].title)
            }
                
            NavigationView {
                RecipeDetailView(recipe: Recipe(from: recipePreviewData[1].fragments.recipeDetails))
                    .navigationTitle(recipePreviewData[1].title)
            }
                
            NavigationView {
                RecipeDetailView(recipe: Recipe(from: recipePreviewData[2].fragments.recipeDetails))
                    .navigationTitle(recipePreviewData[2].title)
            }
        }
        .environmentObject(CurrentUserStore())
    }
}
