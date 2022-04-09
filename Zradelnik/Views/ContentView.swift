//
//  ContentView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var authentication: Authentication

    var body: some View {
        NavigationView {
            RecipeList()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
