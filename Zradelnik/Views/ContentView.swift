//
//  ContentView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                RecipeList()
            }
            .tabItem {
                Label("Recepty", systemImage: "fork.knife")
            }

            NavigationView {
                SettingsHost()
            }
            .tabItem {
                Label("Nastavení", systemImage: "gearshape")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
