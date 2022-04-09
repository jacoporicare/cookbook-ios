//
//  LoadingContent.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 31.03.2022.
//

import SwiftUI

struct LoadingContent<Data, Content>: View where Content: View {
    let status: LoadingStatus<Data>
    let content: (_ data: Data) -> Content

    var body: some View {
        switch status {
        case .loading:
            ProgressView()
        case .error:
            Text("Chyba")
        case .data(let data):
            content(data)
        }
    }
}

enum LoadingStatus<Data> {
    case loading
    case data(Data)
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

            LoadingContent(status: .data("Hello")) { data in
                Text(data)
            }
        }
    }
}
