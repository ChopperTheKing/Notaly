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
    var onBack: () -> Void

    var body: some View {
        HStack {
            Spacer()
            Text(title)
                .font(.custom("Copperplate", size: 20)) // Apply Copperplate font here
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.2)) // Just an example styling
    }
}
