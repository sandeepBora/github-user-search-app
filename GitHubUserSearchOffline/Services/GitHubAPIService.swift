//
//  GitHubAPIService.swift
//  GitHubUserSearchOffline
//
//  Created by B Sandeep on 17/07/2025.
//

import Foundation

/// Service for communicating with GitHub API.
class GitHubAPIService {
    private let base = "https://api.github.com"

    enum APIError: Error {
        case invalidURL, userNotFound, decodingError
    }

    /// Fetches user profile from GitHub.
    func fetchUser(username: String) async throws -> User {
        guard let url = URL(string: "\(base)/users/\(username)") else {
            throw APIError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw APIError.userNotFound
        }
        return try JSONDecoder().decode(User.self, from: data)
    }

    /// Fetches repositories of the GitHub user.
    func fetchRepositories(username: String) async throws -> [Repository] {
        guard let url = URL(string: "\(base)/users/\(username)/repos") else {
            throw APIError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw APIError.userNotFound
        }
        return try JSONDecoder().decode([Repository].self, from: data)
    }
}
