//
//  SettingsView.swift
//  Notaly
//
//  Created by Ronnie Kissos on 12/26/23.
//

import SwiftUI

struct SettingsView: View {
    @State private var notes = [Note]()
    @State private var showingFolders = false
    @State private var selectedTab = 1
    @State private var showingAddNote = false // State to control the presentation of AddNoteView
    @State private var selectedNote: Note?
    @State private var activeNote: Note? = nil // State to control navigation
    @State private var isNoteViewActive = false
    
    var body: some View {
            NavigationStack {
                ZStack {
                    Color.white.ignoresSafeArea()
                    VStack {
                        CustomNavigationView(
                            leadingAction: { showingFolders.toggle() },
                            trailingAction: { isNoteViewActive = true }, // Sets the state to true to activate NavigationLink
                            logo: Image("logo")
                        )
                        .padding([.horizontal, .top])
                        .background(Color.white)
                        .foregroundColor(.black)
                        
                        
                        List {
                            Section(header: Text("Settings").font(.custom("Copperplate", size: 64))) {
                                ForEach(notes) { note in
                                    HStack {
                                        Button(action: {
                                            // Reset activeNote to nil before setting it to the current note
                                            self.activeNote = nil
                                            // Small delay to ensure the state change is recognized
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                self.activeNote = note
                                            }
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
                                        .buttonStyle(PlainButtonStyle())
                                        .background(
                                            NavigationLink("", destination: AddNoteView(notes: $notes, note: note), isActive: Binding(
                                                get: { self.activeNote == note },
                                                set: { _ in }
                                            )).hidden()
                                        )
                                        Spacer()
                                    }
                                    .frame(width: 329, height: 60, alignment: .leading)
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                                }
                                .onDelete(perform: deleteNote)
                                .padding(.horizontal)
                            }
                            .foregroundColor(Color(red: 87 / 255, green: 87 / 255, blue: 87 / 255))
                        }
                        .listStyle(.plain)
                        
                        .navigationDestination(isPresented: $isNoteViewActive) {
                            AddNoteView(notes: $notes) // Adjust as per your AddNoteView initializer
                        }
                    }
                }
            }
        }
    
    
    private func deleteNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
    }
}

