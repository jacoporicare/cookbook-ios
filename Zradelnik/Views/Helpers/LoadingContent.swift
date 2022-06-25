//
//  LoadingContent.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 31.03.2022.
//

import SwiftUI

struct LoadingContent<Content>: View where Content: View {
    var status: LoadingStatus
    @ViewBuilder var content: () -> Content

    var body: some View {
        switch status {
        case .loading:
            ProgressView()
        case .error:
            Text("Chyba")
        case .data:
            content()
        }
    }
}

enum LoadingStatus {
    case loading
    case data
    case error
}

struct LoadingContent_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoadingContent(status: .loading) {
                Text("OK")
            }

            LoadingContent(status: .error) {
                Text("OK")
            }

            LoadingContent(status: .data) {
                Text("Data")
            }
        }
    }
}
