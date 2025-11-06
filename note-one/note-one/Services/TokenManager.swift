//
//  TokenManager.swift
//  note-one
//
//  Created by Tolga Bayrak on 6.11.2025.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()
    
    private let tokenKey = "auth_token"
    private let userKey = "user_data"
    
    private init() {}
    
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userKey)
        }
    }
    
    func getUser() -> User? {
        guard let data = UserDefaults.standard.data(forKey: userKey),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        return user
    }
    
    func clearAuth() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.removeObject(forKey: userKey)
    }
    
    var isAuthenticated: Bool {
        return getToken() != nil
    }
}

