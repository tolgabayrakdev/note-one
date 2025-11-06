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
        guard let token = UserDefaults.standard.string(forKey: tokenKey) else {
            return nil
        }
        
        // Token'ın geçerliliğini kontrol et
        if isTokenValid(token) {
            return token
        } else {
            // Token süresi dolmuş, temizle
            clearAuth()
            return nil
        }
    }
    
    private func isTokenValid(_ token: String) -> Bool {
        // JWT token formatı: header.payload.signature
        let parts = token.components(separatedBy: ".")
        guard parts.count == 3 else { return false }
        
        // Payload'ı decode et
        guard let payloadData = base64UrlDecode(parts[1]),
              let payload = try? JSONSerialization.jsonObject(with: payloadData) as? [String: Any],
              let exp = payload["exp"] as? TimeInterval else {
            return false
        }
        
        // Expiry kontrolü (exp Unix timestamp)
        let expirationDate = Date(timeIntervalSince1970: exp)
        return expirationDate > Date()
    }
    
    private func base64UrlDecode(_ base64Url: String) -> Data? {
        var base64 = base64Url
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        // Padding ekle
        let remainder = base64.count % 4
        if remainder > 0 {
            base64 = base64.padding(toLength: base64.count + 4 - remainder, withPad: "=", startingAt: 0)
        }
        
        return Data(base64Encoded: base64)
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

