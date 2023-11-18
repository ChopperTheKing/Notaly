//
//  AddNoteView.swift
//  Notaly
//
//  Created by Ronnie Kissos on 11/13/23.
//

import SwiftUI

struct AddNoteView: View {
    @Binding var notes: [Note]
    @State private var title = ""
    @State private var rawContent = ""
    @State private var note: Note?
    
    @FocusState private var isTitleFocused: Bool // Focus state for the content field
    @FocusState private var isContentFocused: Bool // Focus state for the content field
    
    @Environment(\.presentationMode) var presentationMode

    init(notes: Binding<[Note]>, note: Note? = nil) {
        _notes = notes
        _note = State(initialValue: note)
        if let editingNote = note {
            _title = State(initialValue: editingNote.title)
            _rawContent = State(initialValue: editingNote.content)
        }
    }

    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBarView(title: "New Note") {
                presentationMode.wrappedValue.dismiss()
            }

            Form {
                TextField("Title", text: $title)
                    .focused($isTitleFocused) // Bind the focus state to the TextEditor
                    .onSubmit { // Handle the Enter key press
                        isContentFocused = true // Move focus to the content field
                    }
                TextEditor(text: $rawContent.onChange(addBulletPoints))
                    .focused($isContentFocused) // Bind the focus state to the TextEditor
                    .frame(minHeight: 500)
                Button("Save") {
                    if let editingNote = note {
                        // Find and update the existing note
                        if let index = notes.firstIndex(where: { $0.id == editingNote.id }) {
                            notes[index].title = title
                            notes[index].content = rawContent
                        }
                    } else {
                        // Add a new note
                        let newNote = Note(title: title, content: rawContent)
                        notes.append(newNote)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(title.isEmpty || rawContent.isEmpty)

            }
            
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden(true)
        .onDisappear {
            saveNote() // Save the note when the view disappears
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isTitleFocused = true // Focus on the TextEditor when the view appears
            }
        }
    }
    
    private func saveNote() {
        if !title.isEmpty || !rawContent.isEmpty {
            let newNote = Note(title: title, content: rawContent)
            notes.append(newNote)
        }
    }

    // Function to add bullet points
    func addBulletPoints(_ newText: String) {
        let lines = newText.split(separator: "\n", omittingEmptySubsequences: false)
        let bulletedLines = lines.map { line -> String in
            if line.starts(with: "• ") || line.isEmpty {
                return String(line)
            } else {
                return "• " + line
            }
        }
        rawContent = bulletedLines.joined(separator: "\n")
    }
}

// Extension to provide onChange functionality for the TextEditor
extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}

struct AddNoteView_Previews: PreviewProvider {
    @State static var previewNotes = [Note(title: "Sample Note 1", content: "Sample Content 1"),
                                      Note(title: "Sample Note 2", content: "Sample Content 2")]

    static var previews: some View {
        AddNoteView(notes: $previewNotes)
    }
}
