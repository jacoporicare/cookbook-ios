//
//  Extensions.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 09.04.2022.
//

import SwiftUI

extension Image {
    func centerCropped() -> some View {
        GeometryReader { geo in
            self
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
        }
    }
}
