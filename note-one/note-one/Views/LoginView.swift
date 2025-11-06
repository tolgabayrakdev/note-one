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
    @State private var showPassword = false
    @State private var showRegister = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Notlarım")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)
            
            VStack(spacing: 16) {
                TextField("E-posta", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .paddedTextFieldStyle()
                
                HStack {
                    if showPassword {
                        TextField("Şifre", text: $password)
                            .textContentType(.none)
                            .autocorrectionDisabled()
                    } else {
                        SecureField("Şifre", text: $password)
                            .textContentType(.none)
                            .autocorrectionDisabled()
                    }
                    
                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                
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
                    (Text("Hesabınız yok mu? ") + Text("Kayıt olun").underline())
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

