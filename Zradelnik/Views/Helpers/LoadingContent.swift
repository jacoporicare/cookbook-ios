//
//  LoadingContent.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 31.03.2022.
//

import SwiftUI

struct LoadingContent<Content: View, ErrorContent: View>: View {
    var status: LoadingStatus
    var loadingText: String = "Načítání..."
    @ViewBuilder var content: () -> Content
    @ViewBuilder var errorContent: (String) -> ErrorContent

    var body: some View {
        switch status {
        case .loading:
            VStack(spacing: 8) {
                ProgressView()

                Text(loadingText)
                    .foregroundColor(.secondary)
            }
        case .error(let err):
            errorContent(err)
        case .data:
            content()
        }
    }
}

enum LoadingStatus {
    case loading
    case data
    case error(String)
}

struct LoadingContent_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoadingContent(status: .loading) {
                Text("OK")
            } errorContent: { _ in
                Text("Error")
            }

            LoadingContent(status: .error("Some error here")) {
                Text("OK")
            } errorContent: { err in
                Text("Error: \(err)")
            }

            LoadingContent(status: .data) {
                Text("Data")
            } errorContent: { _ in
                Text("Error")
            }
        }
    }
}
