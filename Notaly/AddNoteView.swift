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
    
    @FocusState private var isTitleFocused: Bool
    @FocusState private var isContentFocused: Bool
    
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
        VStack(spacing: -10) { // Maintain the reduced spacing
            // Title box
            ZStack {
                Rectangle()
                    .foregroundColor(Color(red: 0.97, green: 0.97, blue: 0.97))
                    .frame(width: 329, height: 60)
                    .cornerRadius(2)
                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)

                TextField("Title", text: $title)
                    .focused($isTitleFocused)
                    .onSubmit {
                        // Shift focus to the content when 'Enter' is pressed
                        isContentFocused = true
                        addInitialBulletPoint()
                    }
                    .font(.custom("Copperplate", size: 24))
                    .foregroundColor(Color(red: 87 / 255, green: 87 / 255, blue: 87 / 255))
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.top, -20)
            .padding(.horizontal, 20)
            .padding(.bottom, -10)

            // Content area
            TextEditor(text: $rawContent.onChange(addBulletPoints))
                .font(.custom("Copperplate", size: 20))
                .focused($isContentFocused)
                .foregroundColor(Color(red: 87 / 255, green: 87 / 255, blue: 87 / 255))
                .padding(EdgeInsets(top: 5, leading: 32, bottom: 0, trailing: 32)) // Further reduced top padding for content
                .frame(minHeight: 600)
                .cornerRadius(2)
                .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
                .gesture(DragGesture(minimumDistance: 30, coordinateSpace: .local)
                    .onEnded { value in
                        if value.translation.width > 0 {
                            // Right swipe - Indent the line
                            indentLine(direction: .right)
                        } else if value.translation.width < 0 {
                            // Left swipe - Outdent the line
                            indentLine(direction: .left)
                        }
                    })
        }
        .padding(.top, 10)
        .background(Color(red: 0.97, green: 0.97, blue: 0.97))
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




    // Add the saveNote function here
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


    private var focusedText: String {
        if isTitleFocused {
            return "Editing Title"
        } else if isContentFocused {
            return "Editing Content"
        } else {
            return "New Note"
        }
    }
    
    private func indentLine(direction: SwipeDirection) {
        // Split the content into lines
        var lines = rawContent.components(separatedBy: .newlines)

        // Determine the current line index based on the cursor position
        // This is a simplified approach. In a real app, you would need to find the line where the cursor currently is.
        let currentLineIndex = lines.count - 1 // Assuming the cursor is at the last line for simplicity

        guard currentLineIndex >= 0 && currentLineIndex < lines.count else { return }

        let currentLine = lines[currentLineIndex]

        switch direction {
        case .right:
            // Indent the line by adding a tab or spaces
            lines[currentLineIndex] = "\t" + currentLine

        case .left:
            // Outdent the line by removing a tab or spaces if present
            lines[currentLineIndex] = currentLine.replacingOccurrences(of: "^\t", with: "", options: .regularExpression)
        }

        // Join the lines back together
        rawContent = lines.joined(separator: "\n")
    }

    


    // Function to add bullet points
    func addBulletPoints(_ newText: String) {
        // Split the content into lines
        var lines = newText.split(separator: "\n", omittingEmptySubsequences: false)
        var processedLines: [String] = []
        var lastIndentation = ""

        for line in lines {
            if line.isEmpty {
                // If the line is empty, it's a new line after pressing Enter
                // Use the last known indentation and add a bullet point
                processedLines.append("\(lastIndentation)• ")
            } else {
                // Extract the indentation from the current line
                let currentIndentation = line.prefix(while: { $0 == "\t" || $0 == " " })
                lastIndentation = String(currentIndentation)

                let trimmedLine = line.trimmingCharacters(in: .whitespaces)

                // Check if the line already has a bullet point
                if trimmedLine.hasPrefix("•") {
                    // Line already starts with a bullet point, keep it as is
                    processedLines.append(String(line))
                } else {
                    // Line does not have a bullet point, add it
                    processedLines.append("\(lastIndentation)• \(trimmedLine)")
                }
            }
        }

        // Join the processed lines back together
        rawContent = processedLines.joined(separator: "\n")
    }



    private func addInitialBulletPoint() {
        // Add an initial bullet point if the content is empty
        if rawContent.isEmpty {
            rawContent = "• "
        }
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

enum SwipeDirection {
    case left, right
}

