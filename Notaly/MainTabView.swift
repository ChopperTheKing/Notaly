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

    var body: some View {
        TabView(selection: $selectedTab) {
            NotesListView()
                .tabItem {
                    EmptyView() // Empty because CustomTabBarView will handle the display
                }
                .tag(0)

            SettingsView()
                .tabItem {
                    EmptyView() // Empty because CustomTabBarView will handle the display
                }
                .tag(1)
        }
        .overlay(
            VStack {
                Spacer()
                CustomTabBarView(selectedTab: $selectedTab)
            },
            alignment: .bottom
        )
    }
}
