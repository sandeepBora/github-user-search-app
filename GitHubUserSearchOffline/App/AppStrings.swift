//
//  AppStrings.swift
//  GitHubUserSearchOffline
//
//  Created by B Sandeep on 17/07/2025.
//

import Foundation

import Foundation

/// Centralized user-facing strings used throughout the UI.
enum AppStrings {
    // MARK: - Search
    static let searchPlaceholder = "Enter GitHub username"
    static let searchButton = "Search"
    static let searchTitle = "Search GitHub"

    // MARK: - Profile
    static let profileTitle = "Profile"
    static let profileFollowers = "Followers"
    static let profileRepos = "Repos"
    static let profileBioUnavailable = "No bio available"

    // MARK: - Repositories
    static let repoSectionTitle = "Repositories"
    static let noRepos = "No public repositories."
    static let repoStars = "star"
    static let repoForks = "tuningfork"
    static let loadingRepos = "Loading Repositories..."
    static let errorLoadingRepos = "Error loading repositories"

    // MARK: - MainTabView
    static let tabSearchLabel = "Search"
    static let tabSearchIcon = "magnifyingglass"

    static let tabHistoryLabel = "History"
    static let tabHistoryIcon = "clock"

    // MARK: - SearchHistoryView
    static let historyTitle = "Recent Searches"
    static let historyErrorTitle = "Error"
    static let historyErrorOK = "OK"
    static let historyLoading = "Loading..."
}
