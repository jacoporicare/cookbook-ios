//
//  RecipeLastCooked.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 03.11.2022.
//

import SwiftUI

struct RecipeLastCooked: View {
    let cooked: Recipe.Cooked
    let history: [Recipe.Cooked]
    let onCookedDelete: (String) -> Void

    @Environment(CurrentUserStore.self) private var currentUserStore

    @State private var isHistorySheetPresented = false

    var body: some View {
        HStack {
            Text("Naposledy uvařeno:")
                .foregroundColor(.gray)
            Text(cooked.date.formatted(date: .abbreviated, time: .omitted))
            if let user = cooked.user {
                Text("(\(user.displayName))")
            }

            Spacer()

            Button {
                isHistorySheetPresented.toggle()
            } label: {
                Label("Historie", systemImage: "clock.arrow.circlepath")
                    .labelStyle(.iconOnly)
            }
        }
        .font(.callout)
        .sheet(isPresented: $isHistorySheetPresented) {
            NavigationStack {
                List {
                    ForEach(history) { row in
                        HStack {
                            Text(row.date.formatted(date: .abbreviated, time: .omitted))
                            Spacer()
                            if let user = row.user {
                                Text(user.displayName)
                            }
                        }
                    }
                    .onDelete(perform: currentUserStore.isLoggedIn ? { indexSet in
                        guard let index = indexSet.first else { return }
                        onCookedDelete(history[index].id)
                    } : nil)
                }
                .navigationTitle("Historie vaření")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    if currentUserStore.isLoggedIn {
                        EditButton()
                    }
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    RecipeLastCooked(
        cooked: previewRecipes[0].cookedHistory.last!,
        history: previewRecipes[0].cookedHistory,
        onCookedDelete: { _ in }
    )
    .padding()
    .previewStores(isLoggedIn: true)
}
#endif
