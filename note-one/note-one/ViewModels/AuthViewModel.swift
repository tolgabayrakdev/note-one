//
//  AuthViewModel.swift
//  note-one
//
//  Created by Tolga Bayrak on 6.11.2025.
//

import Foundation
import SwiftUI
import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService = APIService.shared
    private let tokenManager = TokenManager.shared
    
    init() {
        checkAuthentication()
    }
    
    func checkAuthentication() {
        if tokenManager.getToken() != nil, let user = tokenManager.getUser() {
            DispatchQueue.main.async {
                self.isAuthenticated = true
                self.currentUser = user
            }
        }
    }
    
    @MainActor
    func register(username: String, email: String, password: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            let request = RegisterRequest(username: username, email: email, password: password)
            _ = try await apiService.register(request)
            
            // Kayıt başarılı ama otomatik login yapmıyoruz
            // Token ve user bilgilerini kaydetmiyoruz
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    @MainActor
    func login(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let request = LoginRequest(email: email, password: password)
            let response = try await apiService.login(request)
            
            tokenManager.saveToken(response.token)
            tokenManager.saveUser(response.user)
            
            isAuthenticated = true
            currentUser = response.user
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    @MainActor
    func logout() {
        tokenManager.clearAuth()
        isAuthenticated = false
        currentUser = nil
    }
}

