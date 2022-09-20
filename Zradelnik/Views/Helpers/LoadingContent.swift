//
//  LoadingContent.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 31.03.2022.
//

import SwiftUI

struct LoadingContent<Content>: View where Content: View {
    var status: LoadingStatus
    var onRetry: () -> Void
    @ViewBuilder var content: () -> Content

    var body: some View {
        switch status {
        case .loading:
            ProgressView()
        case .error(let err):
            VStack {
                Text("Chyba")
                    .font(.title)

                Text("Recepty se nepodařilo načíst.")

                Button {
                    onRetry()
                } label: {
                    Label("Zkusit znovu", systemImage: "arrow.clockwise")
                }
                .padding(.top)

                Text(err)
                    .font(.footnote.monospaced())
                    .padding(.top)
            }
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
            LoadingContent(status: .loading, onRetry: {}) {
                Text("OK")
            }

            LoadingContent(status: .error("Some error here"), onRetry: {}) {
                Text("Error")
            }

            LoadingContent(status: .data, onRetry: {}) {
                Text("Data")
            }
        }
    }
}
