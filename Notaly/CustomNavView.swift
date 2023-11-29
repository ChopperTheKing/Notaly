//
//  CustomNavView.swift
//  Notaly
//
//  Created by Ronnie Kissos on 11/29/23.
//

import Foundation
import SwiftUI

struct CustomNavigationView: View {
    var leadingAction: () -> Void
    var trailingAction: () -> Void
    var logo: Image

    var body: some View {
        HStack {
//            Button(action: leadingAction) {
//                Image("folder")
//                    .imageScale(.large)
//            }
            Button(action: leadingAction) {
                Color.clear
                    .frame(width: 24, height: 24) // Adjust the frame to match the size of your visible buttons
            }

            Spacer()

            logo
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 30)

            Spacer()

            Button(action: trailingAction) {
                Image("plus")
                    .imageScale(.large)
            }
        }
        //.padding()
        .background(Color.white) // Customize the background color as needed
        .foregroundColor(.black)
        //.shadow(radius: 2) // Optional: Add a shadow for a more distinct look
    }
}
