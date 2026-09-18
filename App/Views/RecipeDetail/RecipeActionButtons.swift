//
//  RecipeActionButtons.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 03.11.2022.
//

import SwiftUI

struct RecipeActionButtons: View {
    @Binding var isCookedDatePickerVisible: Bool

    let isUserLoggedIn: Bool

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
                        isCookedDatePickerVisible.toggle()
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

#if DEBUG
#Preview("Logged out") {
    RecipeActionButtons(isCookedDatePickerVisible: .constant(false), isUserLoggedIn: false)
}

#Preview("Logged in") {
    RecipeActionButtons(isCookedDatePickerVisible: .constant(false), isUserLoggedIn: true)
}
#endif
