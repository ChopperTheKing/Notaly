//
//  CustomTabBarView.swift
//  Notaly
//
//  Created by Ronnie Kissos on 11/24/23.
//

import Foundation
import SwiftUI

struct CustomTabBarView: View {
    @Binding var selectedTab: Int

    private func indicatorOffset() -> CGFloat {
        let tabWidth = UIScreen.main.bounds.width / 2
        let indicatorWidth: CGFloat = 150
        let offsetAdjustment: CGFloat = (tabWidth - indicatorWidth) / 2

        let additionalOffsetForSettings: CGFloat = selectedTab == 1 ? -46 : 0 // Adjust this value as needed

        return CGFloat(selectedTab) * tabWidth + offsetAdjustment - tabWidth / 2 + additionalOffsetForSettings
    }


    var body: some View {
        VStack {
            HStack {
                Spacer() // Add a spacer before the first button

                Button(action: {
                    withAnimation {
                        self.selectedTab = 0
                    }
                }) {
                    Image("lists_unselected")
                        .font(.system(size: 24))
                }
                .padding(.horizontal)

                Spacer() // Spacer between buttons

                Button(action: {
                    withAnimation {
                        self.selectedTab = 1
                    }
                }) {
                    Image("settings_unselected")
                        .font(.system(size: 24))
                }
                .padding(.horizontal)

                Spacer() // Add a spacer after the last button
            }
            .padding(.top, 10)

            // Selection indicator
            Rectangle()
                .frame(width: 42, height: 2)
                .foregroundColor(.black) // Change to your desired color
                .offset(x: indicatorOffset(), y: 0)
                .animation(.easeInOut, value: selectedTab)
        }
        .frame(height: 100)
        .frame(maxWidth: .infinity)
        .background(
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 393, height: 100)
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.81, green: 0.81, blue: 0.81).opacity(0), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.6, green: 0.6, blue: 0.6), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.5, y: 0),
                        endPoint: UnitPoint(x: 0.5, y: 1)
                    )
                )
        )
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct CustomTabBarView_Previews: PreviewProvider {
    @State static var selectedTab = 0 // Define a @State variable for the selected tab
    
    static var previews: some View {
        CustomTabBarView(selectedTab: $selectedTab)
    }
}
