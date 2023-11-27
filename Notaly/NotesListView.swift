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
    @State private var showingFolders = false
    @State private var selectedNote: Note? // For full screen cover
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Set the background to white and make it ignore the safe area to cover the whole screen
                Color.white.ignoresSafeArea()
                
                List {
                    Section(header:
                                HStack {
                        Text("Lists")
                            .font(.custom("Copperplate", size: 64))
                            .padding(.leading, 32)
                            .padding(.top, 24)
                            .padding(.bottom, 32)
                            .foregroundColor(Color(red: 87 / 255, green: 87 / 255, blue: 87 / 255))
                        
                        Spacer()
                    }
                        .frame(height: 68, alignment: .leading)
                        .listRowInsets(EdgeInsets())
                    ) {
                        ForEach(notes) { note in
                            Button(action: {
                                selectedNote = note // Assign the selected note
                            }) {
                                //NavigationLink(destination: AddNoteView(notes: $notes, note: note)) {
                                ZStack {
                                    // Background characteristics for each cell
                                    Rectangle()
                                        .foregroundColor(Color(red: 0.97, green: 0.97, blue: 0.97))
                                        .frame(width: 329, height: 60)
                                        .cornerRadius(2)
                                        .shadow(color: .black.opacity(0.25), radius: 4.5, x: 0, y: 4)
                                        //.border(Color.gray, width: 1) // Add a hard border instead of a shadow
                                    // Text for each cell
                                    HStack {
                                        Text(note.title)
                                            .font(.custom("Copperplate", size: 24))
                                            .foregroundColor(Color(red: 87 / 255, green: 87 / 255, blue: 87 / 255))
                                            .padding(.leading, 20)
                                        Spacer()
                                    }
                                }
                            }
                                .frame(width: 329, height: 60, alignment: .leading)
                            //}
                            .listRowBackground(Color.clear) // Make each list row's background clear
                            .listRowSeparator(.hidden) // Hide the row separators
                            .buttonStyle(PlainButtonStyle()) // Remove any default button styling applied by NavigationLink
                            .fullScreenCover(item: $selectedNote) { note in
                                // Pass the selected note to the detail view you want to present
                                AddNoteView(notes: $notes, note: note)
                            }
                        }
                        .padding(.horizontal)
                        
                        
                    }
                }
                .listStyle(.plain) // Apply the plain list style to remove default list formatting
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showingFolders = true }) {
                        Image("folder")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddNote = true }) {
                        Image("plus")
                    }
                }
            }
            .sheet(isPresented: $showingFolders) {
                FoldersView()
            }
            .sheet(isPresented: $showingAddNote) {
                AddNoteView(notes: $notes)
            }
        }
        CustomTabBarView(selectedTab: $selectedTab)
    }
    
    private func deleteNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
    }
}

struct NotesListView_Previews: PreviewProvider {
    static var previews: some View {
        NotesListView()
    }
}

// Custom View Modifier to hide the disclosure indicator
struct HideDisclosureIndicator: ViewModifier {
    func body(content: Content) -> some View {
        content
            .accessibilityHidden(true)
    }
}

// Extension to apply the modifier more easily
extension View {
    func hideDisclosureIndicator() -> some View {
        modifier(HideDisclosureIndicator())
    }
}
