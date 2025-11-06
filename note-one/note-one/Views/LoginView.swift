//
//  LoginView.swift
//  note-one
//
//  Created by Tolga Bayrak on 6.11.2025.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showRegister = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Notlarım")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)
            
            VStack(spacing: 16) {
                TextField("E-posta", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                SecureField("Şifre", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.none)
                    .autocorrectionDisabled()
                
                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button(action: {
                    Task {
                        await authViewModel.login(email: email, password: password)
                    }
                }) {
                    if authViewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Giriş Yap")
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(authViewModel.isLoading || email.isEmpty || password.isEmpty)
                
                Button(action: {
                    showRegister = true
                }) {
                    Text("Hesabınız yok mu? Kayıt olun")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
        .sheet(isPresented: $showRegister) {
            RegisterView(authViewModel: authViewModel, registeredEmail: $email)
        }
    }
}

#Preview {
    LoginView(authViewModel: AuthViewModel())
}

