//
//  User.swift
//  GitHubUserSearchOffline
//
//  Created by B Sandeep on 17/07/2025.
//

import Foundation

/// Represents a GitHub user returned by the GitHub API.
struct User: Codable, Identifiable {
    let id: Int
    /// GitHub login/username.
    let login: String
    /// User avatar image URL.
    let avatar_url: URL
    /// Optional bio or description.
    let bio: String?
    /// Number of followers.
    let followers: Int
    /// Number of public repositories.
    let public_repos: Int
}
