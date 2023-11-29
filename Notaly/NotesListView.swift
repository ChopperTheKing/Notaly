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
    @State private var selectedNote: Note? // For sheet
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                VStack {
                    CustomNavigationView(
                        leadingAction: { showingFolders.toggle() },
                        trailingAction: { showingAddNote.toggle() },
                        logo: Image("logo")
                    )
                    //.padding()
                    .padding([.horizontal, .top])
                    .background(Color.white)
                    .foregroundColor(.black)
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
                                    selectedNote = note
                                }) {
                                    ZStack {
                                        Rectangle()
                                            .foregroundColor(Color(red: 0.97, green: 0.97, blue: 0.97))
                                            .frame(width: 329, height: 60)
                                            .cornerRadius(2)
                                            .shadow(color: .black.opacity(0.25), radius: 4.5, x: 0, y: 4)
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
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .buttonStyle(PlainButtonStyle())
                                .fullScreenCover(item: $selectedNote) { note in
                                    AddNoteView(notes: $notes, note: note)
                                }
                            }
                            .onDelete(perform: deleteNote)
                            .padding(.horizontal)
                        }
                    }
                    .listStyle(.plain)
                }
                .sheet(item: $selectedNote, onDismiss: { selectedNote = nil }) { note in
                    AddNoteView(notes: $notes, note: note)
                }
                .sheet(isPresented: $showingFolders) {
                    Text("Folders View")
                }
                .sheet(isPresented: $showingAddNote) {
                    AddNoteView(notes: $notes)
                }
            }
        }
        //CustomTabBarView(selectedTab: $selectedTab)
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
