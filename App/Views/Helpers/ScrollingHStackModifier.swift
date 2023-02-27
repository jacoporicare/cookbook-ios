//
//  ScrollingHStackModifier.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 27.02.2023.
//

import SwiftUI

struct ScrollingHStackModifier: ViewModifier {
    @State private var scrollOffset = 0.0
    @GestureState private var gestureOffset = 0.0
    
    var items: Int
    var itemWidth: CGFloat
    var itemSpacing: CGFloat
    
    func body(content: Content) -> some View {
        content
            .offset(x: scrollOffset + gestureOffset, y: 0)
            .gesture(DragGesture()
                .updating($gestureOffset) { currentState, gestureState, _ in
                    gestureState = currentState.translation.width
                }
                .onEnded { event in
                    scrollOffset += event.translation.width
                        
                    var index = (-scrollOffset / (itemWidth + itemSpacing)).rounded()
                    index = max(0, min(index, CGFloat(items) - 1))
                        
                    let newOffset = index * (itemWidth + itemSpacing) * -1
                        
                    withAnimation {
                        scrollOffset = newOffset
                    }
                }
            )
    }
}
