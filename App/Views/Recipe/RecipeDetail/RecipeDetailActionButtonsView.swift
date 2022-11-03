//
//  RecipeDetailActionButtonsView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 03.11.2022.
//

import SwiftUI

struct RecipeDetailActionButtonsView: View {
    var isUserLoggedIn: Bool
    @Binding var cookedDatePickerVisible: Bool

    @State private var isIdleTimerDisabled = UIApplication.shared.isIdleTimerDisabled

    var body: some View {
        HStack {
            Spacer()

            Button {
                isIdleTimerDisabled.toggle()
                UIApplication.shared.isIdleTimerDisabled = isIdleTimerDisabled
            } label: {
                Label("Nezhasínat displej", systemImage: isIdleTimerDisabled ? "sun.max.fill" : "sun.max")
            }

            if isUserLoggedIn {
                Spacer()

                Button {
                    withAnimation {
                        cookedDatePickerVisible.toggle()
                    }
                } label: {
                    Label("Uvařeno", systemImage: "fork.knife")
                }
            }

            Spacer()
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
}

struct RecipeDetailActionButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RecipeDetailActionButtonsView(
                isUserLoggedIn: false,
                cookedDatePickerVisible: .constant(false)
            )
            RecipeDetailActionButtonsView(
                isUserLoggedIn: true,
                cookedDatePickerVisible: .constant(false)
            )
        }
    }
}
