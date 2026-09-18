//
//  RecipeGridView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 24.09.2022.
//

import CachedAsyncImage
import SwiftUI

/// Two cards per row inside the existing letter sections.
///
/// Built on `List` rather than `ScrollView` + `LazyVGrid` specifically so that
/// `.refreshable` gets the UIKit refresh control. On a bare `ScrollView` the control
/// fails to reclaim its space when it retracts, leaving the content pushed down.
struct RecipeGridView: View {
    let recipeGroups: [RecipeGroup]

    /// The enclosing stack's path. Cards push onto it with a plain `Button` rather
    /// than a `NavigationLink`, because a `NavigationLink` inside a `List` row always
    /// draws a disclosure chevron - it is a row accessory, so no button style
    /// suppresses it.
    @Binding var path: [RecipeRoute]

    @Environment(RecipeStore.self) private var recipeStore

    private enum Layout {
        static let spacing: CGFloat = 16
    }

    var body: some View {
        List {
            ForEach(recipeGroups) { recipeGroup in
                Section {
                    ForEach(recipeGroup.recipes.pairedRows) { row in
                        HStack(spacing: Layout.spacing) {
                            ForEach(row.recipes) { recipe in
                                Button {
                                    path.append(RecipeRoute(recipeId: recipe.id))
                                } label: {
                                    RecipeGridCard(recipe: recipe)
                                }
                                .buttonStyle(.plain)
                            }

                            // Keeps a lone trailing card at half width instead of
                            // stretching it across the row.
                            if row.recipes.count == 1 {
                                Color.clear
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .listRowInsets(EdgeInsets(
                            top: Layout.spacing / 2,
                            leading: Layout.spacing,
                            bottom: Layout.spacing / 2,
                            trailing: Layout.spacing
                        ))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                } header: {
                    Text(recipeGroup.id)
                        .foregroundColor(.gray)
                        .textCase(nil)
                }
                .id(recipeGroup.id)
            }
        }
        .listStyle(.plain)
        .refreshable {
            await recipeStore.refresh()
        }
    }
}

/// A row of the two-column layout.
private struct RecipeCardRow: Identifiable {
    let id: String
    let recipes: [Recipe]
}

private extension [Recipe] {
    /// Chunks into rows of two, preserving order.
    var pairedRows: [RecipeCardRow] {
        stride(from: 0, to: count, by: 2).map { index in
            let recipes = Array(self[index ..< Swift.min(index + 2, count)])
            return RecipeCardRow(id: recipes[0].id, recipes: recipes)
        }
    }
}

struct RecipeGridCard: View {
    let recipe: Recipe

    var body: some View {
        VStack(spacing: 0) {
            if let imageUrl = recipe.gridImageUrl {
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
                .modifier(CardImageModifier(recipe: recipe))
            } else {
                placeholder
            }
        }
        .background(.background)
        .cornerRadius(8)
        .shadow(radius: 8)
    }

    private var placeholder: some View {
        Image(systemName: "fork.knife.circle")
            .resizable()
            .scaledToFit()
            .symbolRenderingMode(.hierarchical)
            .foregroundColor(.black)
            .padding()
            .modifier(CardImageModifier(recipe: recipe))
    }

    private struct CardImageModifier: ViewModifier {
        let recipe: Recipe

        func body(content: Content) -> some View {
            content
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .clipped()
                .overlay {
                    RecipeTitleOverlay(recipe: recipe)
                }
        }
    }
}

private struct RecipeTitleOverlay: View {
    let recipe: Recipe

    private var gradient: LinearGradient {
        .linearGradient(
            Gradient(colors: [.black.opacity(0.6), .black.opacity(0)]),
            startPoint: .bottom,
            endPoint: .center
        )
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            gradient

            Text(recipe.title)
                .font(.title3)
                .bold()
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .minimumScaleFactor(0.75)
                .padding()
        }
        .foregroundColor(.white)
    }
}

#if DEBUG
#Preview("Grid") {
    NavigationStack {
        RecipeGridView(recipeGroups: previewRecipes.groupedByFirstLetter(), path: .constant([]))
    }
    .previewStores()
}

#Preview("Card") {
    HStack {
        RecipeGridCard(recipe: previewRecipes[0])
        RecipeGridCard(recipe: previewRecipes[1])
    }
    .padding()
}
#endif
