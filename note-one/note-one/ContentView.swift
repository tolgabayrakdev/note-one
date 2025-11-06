//
//  ContentView.swift
//  note-one
//
//  Created by Tolga Bayrak on 6.11.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var notesViewModel: NotesViewModel
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                NotesListView(
                    notesViewModel: notesViewModel,
                    authViewModel: authViewModel
                )
            } else {
                LoginView(authViewModel: authViewModel)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
        .environmentObject(NotesViewModel())
}
