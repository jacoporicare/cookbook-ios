//
//  RecipeDetailSousVideInfoView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 17.11.2022.
//

import SwiftUI

struct RecipeDetailSousVideInfoView: View {
    @State private var infoVisible = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Sous-vide recept")
                Spacer()
                Label("Více informací", systemImage: "info.circle")
                    .labelStyle(.iconOnly)
                    .foregroundColor(.accentColor)
            }

            if infoVisible {
                Text("Recept je určený pro přípravu metodou sous-vide, tedy pomalé vaření ve vakuově uzavřeném obalu ve vodní lázni s přesně kontrolovanou teplotou.")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(uiColor: .systemGray6))
        .cornerRadius(8)
        .onTapGesture {
            withAnimation {
                infoVisible.toggle()
            }
        }
    }
}

struct RecipeDetailSousVideInfoView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailSousVideInfoView()
    }
}
