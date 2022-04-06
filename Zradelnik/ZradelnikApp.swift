//
//  ZradelnikApp.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import SwiftUI

@main
struct ZradelnikApp: App {
    @StateObject private var authentication = Authentication()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authentication)
        }
    }
}
