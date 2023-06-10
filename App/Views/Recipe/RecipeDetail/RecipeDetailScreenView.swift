//
//  RecipeDetailScreenView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 08.04.2022.
//

import CachedAsyncImage
import MarkdownUI
import SwiftUI

struct RecipeDetailScreenView: View {
    let recipe: Recipe
    
    @EnvironmentObject private var routing: Routing
    @EnvironmentObject private var currentUserStore: CurrentUserStore
    
    @StateObject private var vm = RecipeDetailModel()
    @State private var cookedDatePickerVisible = false
    
    var body: some View {
        RecipeDetailTemplateView(
            cookedDatePickerVisible: $cookedDatePickerVisible,
            recipe: recipe,
            isUserLoggedIn: currentUserStore.isLoggedIn,
            isSaving: vm.isSaving,
            onRecipeCook: handleRecipeCook,
            onCookedRecipeDelete: handleCookedRecipeDelete
        )
    }
   
    func handleRecipeCook(cookedDate: Date) {
        vm.recipeCooked(id: recipe.id, date: cookedDate) { newRecipe in
            withAnimation {
                cookedDatePickerVisible.toggle()
            }
            
            guard let newRecipe else { return }
            routing.recipeListStack[routing.recipeListStack.endIndex - 1] = newRecipe
        }
    }
    
    func handleCookedRecipeDelete(cookedId: String) {
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
                RecipeDetailScreenView(recipe: Recipe(from: recipePreviewData[0].fragments.recipeDetails))
                    .navigationTitle(recipePreviewData[0].title)
            }
                
            NavigationView {
                RecipeDetailScreenView(recipe: Recipe(from: recipePreviewData[1].fragments.recipeDetails))
                    .navigationTitle(recipePreviewData[1].title)
            }
                
            NavigationView {
                RecipeDetailScreenView(recipe: Recipe(from: recipePreviewData[2].fragments.recipeDetails))
                    .navigationTitle(recipePreviewData[2].title)
            }
        }
        .environmentObject(CurrentUserStore())
    }
}
