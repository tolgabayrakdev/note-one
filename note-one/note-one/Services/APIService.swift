//
//  APIService.swift
//  note-one
//
//  Created by Tolga Bayrak on 6.11.2025.
//

import Foundation

class APIService {
    static let shared = APIService()
    
    // Backend URL'ini buraya girin (localhost için simulator'da http://localhost:3000, gerçek cihazda IP adresi)
    private let baseURL = "http://localhost:3000/api"
    
    private init() {}
    
    // MARK: - Generic Request Method
    private func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Data? = nil,
        token: String? = nil
    ) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = body
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let errorData = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw APIError.serverError(errorData.error)
            }
            throw APIError.httpError(httpResponse.statusCode)
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            throw APIError.decodingError
        }
    }
    
    // MARK: - Auth Methods
    func register(_ request: RegisterRequest) async throws -> AuthResponse {
        let body = try JSONEncoder().encode(request)
        return try await self.request(endpoint: "/auth/register", method: "POST", body: body)
    }
    
    func login(_ request: LoginRequest) async throws -> AuthResponse {
        let body = try JSONEncoder().encode(request)
        return try await self.request(endpoint: "/auth/login", method: "POST", body: body)
    }
    
    // MARK: - Notes Methods
    func getNotes(token: String) async throws -> [Note] {
        return try await self.request(endpoint: "/notes", token: token)
    }
    
    func getNote(id: Int, token: String) async throws -> Note {
        return try await self.request(endpoint: "/notes/\(id)", token: token)
    }
    
    func createNote(_ request: CreateNoteRequest, token: String) async throws -> Note {
        let body = try JSONEncoder().encode(request)
        return try await self.request(endpoint: "/notes", method: "POST", body: body, token: token)
    }
    
    func updateNote(id: Int, _ request: CreateNoteRequest, token: String) async throws -> Note {
        let body = try JSONEncoder().encode(request)
        return try await self.request(endpoint: "/notes/\(id)", method: "PUT", body: body, token: token)
    }
    
    func deleteNote(id: Int, token: String) async throws {
        let _: EmptyResponse = try await self.request(endpoint: "/notes/\(id)", method: "DELETE", token: token)
    }
}

// MARK: - Error Types
enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case serverError(String)
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Geçersiz URL"
        case .invalidResponse:
            return "Geçersiz yanıt"
        case .httpError(let code):
            return "HTTP Hatası: \(code)"
        case .serverError(let message):
            return message
        case .decodingError:
            return "Veri çözümleme hatası"
        }
    }
}

struct ErrorResponse: Codable {
    let error: String
}

struct EmptyResponse: Codable {}

