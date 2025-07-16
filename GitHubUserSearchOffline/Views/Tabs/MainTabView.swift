//
//  MainTabView.swift
//  GitHubUserSearchOffline
//
//  Created by B Sandeep on 17/07/2025.
//

import SwiftUI

/// Top-level tab navigation for the app.
struct MainTabView: View {
    
    init() {
        setupTabBarAppearance()
    }

    var body: some View {
        TabView {
            UserSearchView()
                .tabItem {
                    Label(AppStrings.tabSearchLabel, systemImage: AppStrings.tabSearchIcon)
                }

            SearchHistoryView()
                .tabItem {
                    Label(AppStrings.tabHistoryLabel, systemImage: AppStrings.tabHistoryIcon)
                }

            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
        }
        .accentColor(AppColor.primary) // Selected tab tint
        .background(AppColor.background.ignoresSafeArea())
    }

    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(AppColor.tabBackground)
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColor.primary)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(AppColor.primary)]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
