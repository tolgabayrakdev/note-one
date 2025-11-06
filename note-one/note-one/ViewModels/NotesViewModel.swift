//
//  NotesViewModel.swift
//  note-one
//
//  Created by Tolga Bayrak on 6.11.2025.
//

import Foundation
import SwiftUI
import Combine

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService = APIService.shared
    private let tokenManager = TokenManager.shared
    
    @MainActor
    func fetchNotes() async {
        guard let token = tokenManager.getToken() else {
            errorMessage = "Oturum bulunamadı"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            notes = try await apiService.getNotes(token: token)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    @MainActor
    func createNote(title: String, content: String) async -> Bool {
        guard let token = tokenManager.getToken() else {
            errorMessage = "Oturum bulunamadı"
            return false
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let request = CreateNoteRequest(title: title, content: content.isEmpty ? nil : content)
            let newNote = try await apiService.createNote(request, token: token)
            notes.insert(newNote, at: 0)
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    @MainActor
    func updateNote(id: Int, title: String, content: String) async -> Bool {
        guard let token = tokenManager.getToken() else {
            errorMessage = "Oturum bulunamadı"
            return false
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let request = CreateNoteRequest(title: title, content: content.isEmpty ? nil : content)
            let updatedNote = try await apiService.updateNote(id: id, request, token: token)
            
            if let index = notes.firstIndex(where: { $0.id == id }) {
                notes[index] = updatedNote
            }
            
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    @MainActor
    func deleteNote(id: Int) async -> Bool {
        guard let token = tokenManager.getToken() else {
            errorMessage = "Oturum bulunamadı"
            return false
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await apiService.deleteNote(id: id, token: token)
            notes.removeAll { $0.id == id }
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
}

