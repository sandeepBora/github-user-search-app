//
//  Repository.swift
//  GitHubUserSearchOffline
//
//  Created by B Sandeep on 17/07/2025.
//

/// Represents a public repository on GitHub.
struct Repository: Codable, Identifiable {
    let id: Int
    /// Name of the repository.
    let name: String
    /// Description of the repository.
    let description: String?
    /// Number of stars.
    let stargazers_count: Int
    /// Number of forks.
    let forks_count: Int
}
