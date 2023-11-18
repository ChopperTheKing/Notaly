//
//  NotesListView.swift
//  Notaly
//
//  Created by Ronnie Kissos on 11/13/23.
//

import SwiftUI

struct NotesListView: View {
    // State variables to manage the list of notes and the state of showing the add note view
    @State private var notes = [Note]()
    @State private var showingAddNote = false

    var body: some View {
        // Using NavigationStack for navigation
        NavigationStack {
            // List to display notes
            List {
                // Looping through each note
                ForEach(notes) { note in
                    // Changing the navigation link to lead to AddNoteView
                    NavigationLink(destination: AddNoteView(notes: $notes, note: note)) {
                        Text(note.title) // Displaying the note's title
                    }
                }
            }
            // Adding a toolbar to the List
            .toolbar {
                // Toolbar item on the leading side of the navigation bar
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Notes")
                        .font(.largeTitle) // Increasing the font size of "Notes"
                        .bold() // Making the text bold
                        .padding(.top, 40) // Adding top padding
                }
                // Toolbar item on the trailing side of the navigation bar
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddNote = true }) {
                        Image(systemName: "plus") // Using a system image for the button
                    }
                    .padding(.top, 20) // Adding top padding to the button
                }
            }
            // Presenting the AddNoteView when showingAddNote is true
            .navigationDestination(isPresented: $showingAddNote) {
                AddNoteView(notes: $notes) // Passing the notes array to AddNoteView
            }
        }
    }
}

struct NotesListView_Previews: PreviewProvider {
    static var previews: some View {
        NotesListView()
    }
}
