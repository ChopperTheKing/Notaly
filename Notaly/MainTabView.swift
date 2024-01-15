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
        .padding(.bottom, isTabBarVisible ? 0 : -100) // Adjust padding to hide the tab bar
        .overlay(
            VStack {
                Spacer()
                CustomTabBarView(selectedTab: $selectedTab)
                    .frame(height: isTabBarVisible ? 100 : 0) // Adjust frame based on visibility
                    .opacity(isTabBarVisible ? 1 : 0) // Adjust opacity based on visibility
            },
            alignment: .bottom
        )
    }
}
