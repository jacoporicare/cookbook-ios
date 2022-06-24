//
//  ContentView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var recipesStack: [Recipe] = []
    
    var body: some View {
        TabView {
            NavigationStack {
                RecipeList(recipesStack: $recipesStack)
            }
            .tabItem {
                Label("Recepty", systemImage: "fork.knife")
            }

            NavigationStack {
                SettingsHost()
            }
            .tabItem {
                Label("Nastavení", systemImage: "gear")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
