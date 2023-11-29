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
                    .font(.custom("Copperplate", size: 18)) // Applying Copperplate font here
                    .focused($isTitleFocused)
                    .onSubmit {
                        isContentFocused = true
                    }

                TextEditor(text: $rawContent.onChange(addBulletPoints))
                    .font(.custom("Copperplate", size: 16)) // Applying Copperplate font here
                    .focused($isContentFocused)
                    .onChange(of: isContentFocused) { focused in
                        if focused && rawContent.isEmpty {
                            rawContent = "• "
                        }
                    }
                    .frame(minHeight: 600)
            }
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden(true)
        .onDisappear {
            saveNote()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isTitleFocused = true
            }
        }
    }
    
    private func saveNote() {
        if let editingNote = note {
            // Update existing note
            if let index = notes.firstIndex(where: { $0.id == editingNote.id }) {
                notes[index].title = title
                notes[index].content = rawContent
            }
        } else if !title.isEmpty || !rawContent.isEmpty {
            // Create a new note only if title or content is not empty
            let newNote = Note(title: title, content: rawContent)
            notes.append(newNote)
        }
    }

    // Function to add bullet points
    func addBulletPoints(_ newText: String) {
        let lines = newText.split(separator: "\n", omittingEmptySubsequences: false)
        var processedLines: [String] = []

        for line in lines {
            if line.isEmpty {
                // If the line is empty, it's a new line after pressing Enter
                processedLines.append("• ")
            } else if line == "• " {
                // If the line is only a bullet point, remove it (backspace pressed on an empty bullet line)
                continue
            } else {
                // If the line starts with a bullet point or has text, keep it
                let adjustedLine = line.starts(with: "• ") ? line : "• " + line
                processedLines.append(String(adjustedLine))
            }
        }

        rawContent = processedLines.joined(separator: "\n")
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
