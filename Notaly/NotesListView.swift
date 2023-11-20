//
//  NotesListView.swift
//  Notaly
//
//  Created by Ronnie Kissos on 11/13/23.
//

import SwiftUI

struct NotesListView: View {
    @State private var notes = [Note]()
    @State private var showingAddNote = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(notes) { note in
                    NavigationLink(destination: AddNoteView(notes: $notes, note: note)) {
                        Text(note.title)
                    }
                }
                .onDelete(perform: deleteNote) // Swipe to delete functionality
            }
            .navigationTitle("Lists")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "folder")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddNote = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationDestination(isPresented: $showingAddNote) {
                AddNoteView(notes: $notes)
            }
        }
    }

    // Function to delete a note
    private func deleteNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
    }
}

struct NotesListView_Previews: PreviewProvider {
    static var previews: some View {
        NotesListView()
    }
}
