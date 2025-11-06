//
//  RegisterView.swift
//  note-one
//
//  Created by Tolga Bayrak on 6.11.2025.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @Binding var registeredEmail: String
    
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showSuccessMessage = false
    
    init(authViewModel: AuthViewModel, registeredEmail: Binding<String> = .constant("")) {
        self.authViewModel = authViewModel
        self._registeredEmail = registeredEmail
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(spacing: 16) {
                    TextField("Kullanıcı Adı", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                    
                    TextField("E-posta", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Şifre", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.none)
                        .autocorrectionDisabled()
                    
                    SecureField("Şifre Tekrar", text: $confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.none)
                        .autocorrectionDisabled()
                    
                    if let errorMessage = authViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    if showSuccessMessage {
                        Text("Hesabınız başarıyla oluşturuldu!")
                            .foregroundColor(.green)
                            .font(.caption)
                            .padding(.vertical, 8)
                    }
                    
                    Button(action: {
                        if password == confirmPassword {
                            Task {
                                let success = await authViewModel.register(username: username, email: email, password: password)
                                if success {
                                    showSuccessMessage = true
                                    // Email'i login ekranına aktar
                                    registeredEmail = email
                                    // 2 saniye sonra login ekranına dön
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        dismiss()
                                    }
                                }
                            }
                        }
                    }) {
                        if authViewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            Text("Kayıt Ol")
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(authViewModel.isLoading || username.isEmpty || email.isEmpty || password.isEmpty || password != confirmPassword)
                    
                    if password != confirmPassword && !confirmPassword.isEmpty {
                        Text("Şifreler eşleşmiyor")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Kayıt Ol")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("İptal") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    RegisterView(authViewModel: AuthViewModel())
}

