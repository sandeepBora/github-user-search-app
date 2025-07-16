//
//  GitHubAPIService.swift
//  GitHubUserSearchOffline
//
//  Created by B Sandeep on 17/07/2025.
//

import Foundation

import Foundation

/// A protocol defining the interface for GitHub API services.
protocol GitHubAPIProtocol {
    /// Fetches a GitHub user's profile.
    /// - Parameter username: The GitHub username.
    /// - Returns: A `User` model for the given username.
    func fetchUser(username: String) async throws -> User

    /// Fetches public repositories for a given GitHub user.
    /// - Parameter username: The GitHub username.
    /// - Returns: An array of `Repository` models.
    func fetchRepositories(username: String) async throws -> [Repository]
}

/// A service responsible for interacting with GitHub's public REST API.
final class GitHubAPIService: GitHubAPIProtocol {
    private let base = "https://api.github.com"
    private let session: URLSession

    /// Initializes a GitHub API service with the given URL session.
    /// - Parameter session: A `URLSession` instance. Defaults to `.shared`.
    init(session: URLSession = .shared) {
        self.session = session
    }

    /// Errors that can occur during GitHub API calls.
    enum APIError: Error {
        /// The URL was invalid.
        case invalidURL
        /// The user was not found (non-200 response).
        case userNotFound
        /// The response could not be decoded into the expected type.
        case decodingError
    }

    /// Fetches a GitHub user's profile.
    //MockURLProtocol/
    /// - Parameter username: The GitHub username.
    /// - Returns: A decoded `User` object.
    /// - Throws: `APIError.invalidURL`, `APIError.userNotFound`, or `APIError.decodingError`.
    func fetchUser(username: String) async throws -> User {
        let endpoint = "\(base)/users/\(username)"
        return try await request(urlString: endpoint)
    }

    /// Fetches the public repositories of a GitHub user.
    ///
    /// - Parameter username: The GitHub username.
    /// - Returns: An array of decoded `Repository` objects.
    /// - Throws: `APIError.invalidURL`, `APIError.userNotFound`, or `APIError.decodingError`.
    func fetchRepositories(username: String) async throws -> [Repository] {
        let endpoint = "\(base)/users/\(username)/repos"
        return try await request(urlString: endpoint)
    }

    /// Makes a network request and decodes the response into the specified type.
    ///
    /// - Parameter urlString: The endpoint URL as a string.
    /// - Returns: A decoded object of type `T` conforming to `Decodable`.
    /// - Throws: `APIError.invalidURL`, `APIError.userNotFound`, or `APIError.decodingError`.
    private func request<T: Decodable>(urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw APIError.userNotFound
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }
}
