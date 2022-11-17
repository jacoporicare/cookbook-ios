//
//  RecipeDetailInstantPotInfoView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 17.11.2022.
//

import SwiftUI

struct RecipeDetailInstantPotInfoView: View {
    @State private var infoVisible = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Instant Pot recept")
                Spacer()
                Label("Více informací", systemImage: "info.circle")
                    .labelStyle(.iconOnly)
                    .foregroundColor(.accentColor)
            }

            if infoVisible {
                Text("Recept je určený pro multifunkční hrnec Instant Pot nebo jeho kopie, např. česká Tesla EliteCook K70.")
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

struct RecipeDetailInstantPotInfoView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailInstantPotInfoView()
    }
}
