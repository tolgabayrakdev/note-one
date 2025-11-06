//
//  User.swift
//  note-one
//
//  Created by Tolga Bayrak on 6.11.2025.
//

import Foundation

struct User: Codable {
    let id: Int
    let username: String
    let email: String
}

struct AuthResponse: Codable {
    let message: String
    let token: String
    let user: User
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct RegisterRequest: Codable {
    let username: String
    let email: String
    let password: String
}

