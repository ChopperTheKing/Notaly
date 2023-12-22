//
//  AddNoteView.swift
//  Notaly
//
//  Created by Ronnie Kissos on 11/13/23.
//

import SwiftUI
import UIKit

struct UITextViewWrapper: UIViewRepresentable {
    @Binding var text: String
    var onDone: (() -> Void)?
    let placeholder: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        textView.font = UIFont(name: "Copperplate", size: 20)
        textView.textColor = UIColor(red: 87 / 255, green: 87 / 255, blue: 87 / 255, alpha: 1)
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.contentInset = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
        if nil != onDone {
            textView.returnKeyType = .done
        }
        if text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
        }
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if text.isEmpty {
            uiView.text = placeholder
            uiView.textColor = UIColor.lightGray
        } else if uiView.text == placeholder {
            uiView.text = text
            uiView.textColor = UIColor(red: 87 / 255, green: 87 / 255, blue: 87 / 255, alpha: 1)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: UITextViewWrapper

        init(_ textViewWrapper: UITextViewWrapper) {
            self.parent = textViewWrapper
        }

        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = UIColor(red: 87 / 255, green: 87 / 255, blue: 87 / 255, alpha: 1)
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = parent.placeholder
                textView.textColor = UIColor.lightGray
            }
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                // Insert bullet point when 'Enter' is pressed
                let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
                let insertionPoint = range.location + text.count
                textView.text = newText.insertingBulletPoint(at: insertionPoint)
                
                // Move the cursor after the bullet point
                let newPosition = textView.position(from: textView.beginningOfDocument, offset: insertionPoint + 2)
                textView.selectedTextRange = textView.textRange(from: newPosition!, to: newPosition!)
                return false
            }
            return true
        }
    }
}

private extension String {
    func insertingBulletPoint(at index: Int) -> String {
        let prefixIndex = self.index(self.startIndex, offsetBy: index)
        let prefix = self[..<prefixIndex]
        let suffix = self[prefixIndex...]
        return "\(prefix)• \(suffix)"
    }
}

struct AddNoteView: View {
    @Binding var notes: [Note]
    @State private var title = ""
    @State private var rawContent = ""
    @State private var note: Note?
    
    @FocusState private var isTitleFocused: Bool
    @FocusState private var isContentFocused: Bool
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    
    init(notes: Binding<[Note]>, note: Note? = nil) {
        _notes = notes
        _note = State(initialValue: note)
        if let editingNote = note {
            _title = State(initialValue: editingNote.title)
            _rawContent = State(initialValue: editingNote.content)
        }
    }
    
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            VStack(spacing: -10) { // Maintain the reduced spacing
                HStack {
                    // Back Button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("back")
                            .offset(x: 15)
                    }
                    .padding()

                    Spacer()

                    // Cancel Button
                    Button(action: {
                        // Define the cancel action
                        dismiss()
                    }) {
                        HStack {
                            Spacer() // Push the content to the center
                            Text("Cancel")
                                .font(.custom("Copperplate", size: 24))
                                .foregroundColor(Color(red: 87/255, green: 87/255, blue: 87/255)) // Set the text color
                                .offset(x: 22)
                            Spacer() // Push the content to the center
                        }

                    }
                    .padding()

                    // Save Button
                    Button(action: {
                        // Action to save changes
                        saveNote()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save")
                            .font(.custom("Copperplate", size: 24)) // Apply font to the Text view
                            .foregroundColor(Color(red: 87/255, green: 87/255, blue: 87/255)) // Set the text color
                            .offset(x: -15)
                    }
                    .padding()

                }
                // Title box
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(red: 0.97, green: 0.97, blue: 0.97))
                        .frame(width: 329, height: 60)
                        .cornerRadius(2)
                        .shadow(color: .black.opacity(0.25), radius: 4.5, x: 0, y: 4)

                    TextField("", text: $title)
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
                UITextViewWrapper(text: $rawContent, placeholder: "")
                    .frame(minHeight: 600) // Set the height for your UITextView
                    .font(.custom("Copperplate", size: 20))
                    .focused($isContentFocused)
                    .foregroundColor(Color(red: 87 / 255, green: 87 / 255, blue: 87 / 255))
                    .padding(EdgeInsets(top: 5, leading: 32, bottom: 0, trailing: 32)) // Further reduced top padding for content
                    .frame(minHeight: 600)
                    .cornerRadius(2)
                    .shadow(color: .black.opacity(0.25), radius: 4.5, x: 0, y: 4)
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
        let lines = newText.split(separator: "\n", omittingEmptySubsequences: false)
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

                if line.trimmingCharacters(in: .whitespaces) == "•" {
                    // If the line is only a bullet point, remove it
                    continue
                } else {
                    // Add a bullet point if it's not already there
                    let adjustedLine = line.starts(with: "\(currentIndentation)• ") ? line : "\(currentIndentation)• " + line.trimmingCharacters(in: .whitespaces)
                    processedLines.append(String(adjustedLine))
                }
            }
        }
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

