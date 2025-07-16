//
//  SearchedUser.swift
//  GitHubUserSearchOffline
//
//  Created by B Sandeep on 17/07/2025.
//

import Foundation

/// Represents a user that was searched and stored locally via Core Data.
struct SearchedUser: Identifiable {
    let id = UUID()
    /// The GitHub login name.
    let login: String
    /// URL to the user’s avatar.
    let avatarURL: String
    /// Date when the user was searched.
    let timestamp: Date
}
