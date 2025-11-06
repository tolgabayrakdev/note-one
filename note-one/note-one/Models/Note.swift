//
//  Note.swift
//  note-one
//
//  Created by Tolga Bayrak on 6.11.2025.
//

import Foundation

struct Note: Codable, Identifiable {
    let id: Int
    let userId: Int
    let title: String
    let content: String?
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case title
        case content
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct CreateNoteRequest: Codable {
    let title: String
    let content: String?
}

