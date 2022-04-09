//
//  RecipeView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 31.03.2022.
//

import SwiftUI

struct RecipeView: View {
    @Environment(\.editMode) private var editMode
    @EnvironmentObject private var authentication: Authentication
    @StateObject private var viewModel = RecipeViewModel()

    let id: String
    let title: String

    var body: some View {
        LoadingContent(status: viewModel.recipe) { recipe in
            Group {
                if editMode?.wrappedValue == .inactive {
                    RecipeDetailView(recipe: recipe)
                } else {
                    RecipeEditView(recipe: recipe) {
                        viewModel.fetch(id: id)
                    }
                }
            }
            .navigationTitle(recipe.title)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetch(id: id)
        }
    }
}
