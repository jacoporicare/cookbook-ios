//
//  ContentView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var routing: Routing

    var body: some View {
        TabView {
            NavigationStack(path: $routing.recipeListStack) {
                RecipesView()
            }
            .tabItem {
                Label("Recepty", systemImage: "fork.knife")
            }

            NavigationStack {
                SettingsView()
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
