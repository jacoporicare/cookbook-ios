//
//  RecipeBasicInfo.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 03.11.2022.
//

import SwiftUI

struct RecipeBasicInfo: View {
    let preparationTime: String?
    let servingCount: String?
    let sideDish: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let preparationTime {
                row("Doba přípravy:", preparationTime)
            }

            if let servingCount {
                row("Počet porcí:", servingCount)
            }

            if let sideDish {
                row("Příloha:", sideDish)
            }
        }
        .font(.callout)
    }

    private func row(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
            Text(value)
        }
    }
}

#if DEBUG
#Preview {
    VStack(alignment: .leading, spacing: 20) {
        RecipeBasicInfo(preparationTime: "10 min", servingCount: "10", sideDish: "brambory")
        RecipeBasicInfo(preparationTime: "10 min", servingCount: nil, sideDish: nil)
        RecipeBasicInfo(preparationTime: nil, servingCount: nil, sideDish: "brambory")
    }
}
#endif
