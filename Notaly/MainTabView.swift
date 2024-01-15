//
//  MainTabView.swift
//  Notaly
//
//  Created by Ronnie Kissos on 12/26/23.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var isTabBarVisible = true

    var body: some View {
        TabView(selection: $selectedTab) {
            NotesListView(isTabBarVisible: $isTabBarVisible)
                .tabItem {
                    EmptyView() // Empty because CustomTabBarView will handle the display
                }
                .tag(0)

            SettingsView(isTabBarVisible: $isTabBarVisible)
                .tabItem {
                    EmptyView() // Empty because CustomTabBarView will handle the display
                }
                .tag(1)
        }
        .padding(.bottom, isTabBarVisible ? 100 : 0) // Conditional padding based on tab bar visibility
        .overlay(
            VStack {
                Spacer()
                if isTabBarVisible {
                    CustomTabBarView(selectedTab: $selectedTab)
                } else {
                    CustomTabBarView(selectedTab: $selectedTab)
                        .frame(width: 0, height: 0) // When not visible, take no space
                }
            },
            alignment: .bottom
        )
    }
}
