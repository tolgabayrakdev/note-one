//
//  NotesListView.swift
//  note-one
//
//  Created by Tolga Bayrak on 6.11.2025.
//

import SwiftUI

struct NotesListView: View {
    @ObservedObject var notesViewModel: NotesViewModel
    @ObservedObject var authViewModel: AuthViewModel
    @State private var showNoteDetail = false
    @State private var selectedNote: Note?
    
    var body: some View {
        NavigationView {
            Group {
                if notesViewModel.isLoading && notesViewModel.notes.isEmpty {
                    ProgressView("Yükleniyor...")
                } else if notesViewModel.notes.isEmpty {
                    VStack {
                        Image(systemName: "note.text")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("Henüz notunuz yok")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Text("Yeni not eklemek için + butonuna tıklayın")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                } else {
                    List {
                        ForEach(notesViewModel.notes) { note in
                            NavigationLink(destination: NoteDetailView(
                                note: note,
                                notesViewModel: notesViewModel
                            )) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(note.title)
                                        .font(.headline)
                                        .lineLimit(1)
                                    
                                    if let content = note.content, !content.isEmpty {
                                        Text(content)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .lineLimit(2)
                                    }
                                    
                                    Text(formatDate(note.updatedAt))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let note = notesViewModel.notes[index]
                                Task {
                                    await notesViewModel.deleteNote(id: note.id)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Notlarım")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        selectedNote = nil
                        showNoteDetail = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        authViewModel.logout()
                    }) {
                        Text("Çıkış")
                            .foregroundColor(.red)
                    }
                }
            }
            .sheet(isPresented: $showNoteDetail) {
                NoteDetailView(
                    note: selectedNote,
                    notesViewModel: notesViewModel
                )
            }
            .refreshable {
                await notesViewModel.fetchNotes()
            }
            .task {
                await notesViewModel.fetchNotes()
            }
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .short
            displayFormatter.locale = Locale(identifier: "tr_TR")
            return displayFormatter.string(from: date)
        }
        
        // Fallback for different date format
        let fallbackFormatter = DateFormatter()
        fallbackFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = fallbackFormatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .short
            displayFormatter.locale = Locale(identifier: "tr_TR")
            return displayFormatter.string(from: date)
        }
        
        return dateString
    }
}

#Preview {
    NotesListView(
        notesViewModel: NotesViewModel(),
        authViewModel: AuthViewModel()
    )
}

