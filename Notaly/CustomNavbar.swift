//
//  CustomNavbar.swift
//  Notaly
//
//  Created by Ronnie Kissos on 11/13/23.
//

import Foundation
import SwiftUI

struct CustomNavigationBarView: View {
    var title: String
    var onDismiss: () -> Void

    var body: some View {
        HStack {
            // Custom Back Button
            Button(action: onDismiss) {
                Image(systemName: "arrow.left")
            }

            Spacer()

            // Title
            Text(title)
                .font(.headline)

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground)) // Match the system background color
    }
}
