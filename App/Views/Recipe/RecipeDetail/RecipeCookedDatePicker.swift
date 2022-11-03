//
//  RecipeCookedDatePicker.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 03.11.2022.
//

import SwiftUI

struct RecipeCookedDatePicker: View {
    var confirmAction: (Date) -> Void
    
    @State private var cookedDate = Date.now
    
    var body: some View {
        VStack {
            HStack {
                DatePicker("Uvařeno dne", selection: $cookedDate, displayedComponents: .date)
                
                Spacer()
                
                Button {
                    confirmAction(cookedDate)
                } label: {
                    Text("Potvrdit")
                        .fontWeight(.bold)
                        .padding(.leading)
                }
            }
            
            Divider()
        }
    }
}

struct RecipeCookedDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCookedDatePicker { cookedDate in
            print(cookedDate)
        }
    }
}
