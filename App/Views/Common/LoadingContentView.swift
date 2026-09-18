//
//  LoadingContentView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 31.03.2022.
//

import SwiftUI

struct LoadingContentView<Content: View, ErrorContent: View>: View {
    let status: LoadingStatus
    var loadingText: String = "Načítání..."
    @ViewBuilder let content: () -> Content
    @ViewBuilder let errorContent: (String) -> ErrorContent

    var body: some View {
        switch status {
        case .loading:
            VStack(spacing: 8) {
                ProgressView()

                Text(loadingText)
                    .foregroundColor(.secondary)
            }
        case .error(let error):
            errorContent(error)
        case .data:
            content()
        }
    }
}

#if DEBUG
#Preview("Loading") {
    LoadingContentView(status: .loading) {
        Text("OK")
    } errorContent: { _ in
        Text("Error")
    }
}

#Preview("Error") {
    LoadingContentView(status: .error("Some error here")) {
        Text("OK")
    } errorContent: { error in
        Text("Error: \(error)")
    }
}

#Preview("Data") {
    LoadingContentView(status: .data) {
        Text("Data")
    } errorContent: { _ in
        Text("Error")
    }
}
#endif
