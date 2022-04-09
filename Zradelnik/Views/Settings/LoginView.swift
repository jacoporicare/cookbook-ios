//
//  LoginView.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 06.04.2022.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authentication: Authentication
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        VStack {
            TextField("Uživatel", text: $viewModel.username)
            SecureField("Heslo", text: $viewModel.password)
            
            Button {
                viewModel.login { accessToken in
                    authentication.updateAccessToken(accessToken: accessToken)
                    dismiss()
                }
            } label: {
                Text("Přihlásit")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(viewModel.loginDisabled ? .gray : .blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.vertical, 10)
            .disabled(viewModel.loginDisabled)
            
            if viewModel.loggingIn {
                ProgressView()
                    .padding(.top)
            }
            
            Spacer()
        }
        .navigationTitle("Přihlášení")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .textInputAutocapitalization(.never)
        .disableAutocorrection(true)
        .textFieldStyle(.roundedBorder)
        .disabled(viewModel.loggingIn)
        .alert("Neplatný uživatel nebo heslo.", isPresented: $viewModel.error) {}
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
