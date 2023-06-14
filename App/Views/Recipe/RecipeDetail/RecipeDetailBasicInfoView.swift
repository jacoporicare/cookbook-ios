//
//  RecipeDetailBasicInfoView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 03.11.2022.
//

import SwiftUI

struct RecipeDetailBasicInfoView: View {
    let preparationTime: String?
    let servingCount: String?
    let sideDish: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let preparationTime {
                HStack {
                    Text("Doba přípravy:")
                        .foregroundColor(.gray)
                    Text(preparationTime)
                }
            }

            if let servingCount {
                HStack {
                    Text("Počet porcí:")
                        .foregroundColor(.gray)
                    Text(servingCount)
                }
            }

            if let sideDish {
                HStack {
                    Text("Příloha:")
                        .foregroundColor(.gray)
                    Text(sideDish)
                }
            }
        }
        .font(.callout)
    }
}

struct RecipeDetailBasicInfoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RecipeDetailBasicInfoView(preparationTime: "10 min", servingCount: "10", sideDish: "brambory")
            RecipeDetailBasicInfoView(preparationTime: "10 min", servingCount: nil, sideDish: nil)
            RecipeDetailBasicInfoView(preparationTime: nil, servingCount: "10", sideDish: nil)
            RecipeDetailBasicInfoView(preparationTime: nil, servingCount: nil, sideDish: "brambory")
        }
    }
}
