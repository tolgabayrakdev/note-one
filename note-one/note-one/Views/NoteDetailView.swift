//
//  NoteDetailView.swift
//  note-one
//
//  Created by Tolga Bayrak on 6.11.2025.
//

import SwiftUI

struct NoteDetailView: View {
    let note: Note?
    @ObservedObject var notesViewModel: NotesViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var content = ""
    @State private var isSaving = false
    
    var isNewNote: Bool {
        note == nil
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Başlık", text: $title)
                    TextEditor(text: $content)
                        .frame(minHeight: 200)
                }
            }
            .navigationTitle(isNewNote ? "Yeni Not" : "Notu Düzenle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        Task {
                            isSaving = true
                            let success: Bool
                            
                            if isNewNote {
                                success = await notesViewModel.createNote(title: title, content: content)
                            } else {
                                success = await notesViewModel.updateNote(id: note!.id, title: title, content: content)
                            }
                            
                            isSaving = false
                            if success {
                                dismiss()
                            }
                        }
                    }
                    .disabled(title.isEmpty || isSaving)
                }
            }
            .onAppear {
                if let note = note {
                    title = note.title
                    content = note.content ?? ""
                }
            }
            .overlay {
                if isSaving {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    ProgressView()
                }
            }
        }
    }
}

#Preview {
    NoteDetailView(
        note: nil,
        notesViewModel: NotesViewModel()
    )
}

