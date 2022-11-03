//
//  RecipeDetailBasicInfoView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 03.11.2022.
//

import SwiftUI

struct RecipeDetailBasicInfoView: View {
    var preparationTime: String?
    var servingCount: String?
    var sideDish: String?

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
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
            .padding(.horizontal)
            .font(.callout)
        }
    }
}

struct RecipeDetailBasicInfoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RecipeDetailBasicInfoView(preparationTime: "10 min", servingCount: "10", sideDish: "brambory")
            RecipeDetailBasicInfoView(preparationTime: "10 min")
            RecipeDetailBasicInfoView(servingCount: "10")
            RecipeDetailBasicInfoView(sideDish: "brambory")
        }
    }
}
