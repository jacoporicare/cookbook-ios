//
//  ScrollingHStackModifier.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 27.02.2023.
//

import SwiftUI

struct ScrollingHStackModifier: ViewModifier {
    @State private var scrollOffset = 0.0
    @State private var dragOffset = 0.0
    
    var items: Int
    var itemWidth: CGFloat
    var itemSpacing: CGFloat
    
    func body(content: Content) -> some View {
        content
            .offset(x: scrollOffset + dragOffset, y: 0)
            .gesture(DragGesture()
                .onChanged { event in
                    dragOffset = event.translation.width
                }
                .onEnded { event in
                    // Scroll to where user dragged
                    scrollOffset += event.translation.width
                    dragOffset = 0
                        
                    var index = (-scrollOffset / (itemWidth + itemSpacing)).rounded()
                    index = max(0, min(index, CGFloat(items) - 1))
                        
                    let newOffset = index * (itemWidth + itemSpacing) * -1
                        
                    // Animate snapping
                    withAnimation {
                        scrollOffset = newOffset
                    }
                }
            )
    }
}
