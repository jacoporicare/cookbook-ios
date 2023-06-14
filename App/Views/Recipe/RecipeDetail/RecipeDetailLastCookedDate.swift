//
//  RecipeDetailLastCookedDate.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 03.11.2022.
//

import SwiftUI

struct RecipeDetailLastCookedDate: View {
    @EnvironmentObject private var currentUserStore: CurrentUserStore

    let cooked: Recipe.Cooked
    let history: [Recipe.Cooked]
    let onRecipeCookedDelete: (String) -> Void

    @State private var isHistorySheetPresented = false

    var body: some View {
        HStack {
            Text("Naposledy uvařeno:")
                .foregroundColor(.gray)
            Text(cooked.date.formatted(date: .abbreviated, time: .omitted))
            Text("(\(cooked.user.displayName))")

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
            NavigationView {
                List {
                    ForEach(history) { row in
                        HStack {
                            Text(row.date.formatted(date: .abbreviated, time: .omitted))
                            Spacer()
                            Text(row.user.displayName)
                        }
                    }
                    .onDelete(perform: currentUserStore.isLoggedIn ? { indexSet in
                        guard let index = indexSet.first else { return }
                        onRecipeCookedDelete(history[index].id)
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

struct RecipeDetailLastCookedDate_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailLastCookedDate(
            cooked: .init(
                id: "2",
                date: Date(),
                user: .init(
                    id: "1",
                    displayName: "Kubik"
                )
            ),
            history: [
                .init(
                    id: "1",
                    date: Date(),
                    user: .init(
                        id: "2",
                        displayName: "Terka"
                    )
                ),
                .init(
                    id: "2",
                    date: Date(),
                    user: .init(
                        id: "1",
                        displayName: "Kubik"
                    )
                )
            ],
            onRecipeCookedDelete: { _ in }
        )
        .environmentObject(CurrentUserStore())
    }
}
