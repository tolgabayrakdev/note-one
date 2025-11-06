//
//  note_oneApp.swift
//  note-one
//
//  Created by Tolga Bayrak on 6.11.2025.
//

import SwiftUI

@main
struct note_oneApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var notesViewModel = NotesViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(notesViewModel)
        }
    }
}
