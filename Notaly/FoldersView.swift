//
//  FoldersView.swift
//  Notaly
//
//  Created by Ronnie Kissos on 11/21/23.
//

import Foundation
import SwiftUI

struct FoldersView: View {
    @State private var folders: [String] = ["Folder 1", "Folder 2"] // Example folder names
    @State private var addingNewFolder = false
    @State private var newFolderName = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(folders, id: \.self) { folder in
                    Text(folder)
                }
                if addingNewFolder {
                    TextField("New Folder", text: $newFolderName, onCommit: addNewFolder)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onAppear {
                            DispatchQueue.main.async {
                                // This is to ensure the keyboard shows up immediately
                                let _ = UIResponder.currentFirstResponder?.becomeFirstResponder()
                            }
                        }
                }
            }
            .navigationTitle("Folders")
            .navigationBarItems(leading: addButton)
        }
    }

    var addButton: some View {
        Button(action: {
            addingNewFolder = true
        }) {
            Image(systemName: "plus")
        }
    }

    func addNewFolder() {
        if !newFolderName.isEmpty {
            folders.append(newFolderName)
        }
        newFolderName = ""
        addingNewFolder = false
    }
}

extension UIResponder {
    static weak var currentFirstResponder: UIResponder? = nil

    public static func firstResponder() -> UIResponder? {
        UIResponder.currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return UIResponder.currentFirstResponder
    }

    @objc func findFirstResponder(_ sender: Any) {
        UIResponder.currentFirstResponder = self
    }
}
