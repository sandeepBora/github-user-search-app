//
//  MockGitHubAPIService.swift
//  GitHubUserSearchOffline
//
//  Created by M Naveen on 17/07/2025.
//

import XCTest
@testable import GitHubUserSearchOffline

/// A mock implementation of `GitHubAPIProtocol` used for unit testing `SearchHistoryViewModel`.
final class MockGitHubAPIService: GitHubAPIProtocol {
    /// Determines whether the mock should simulate an error.
    var shouldThrowError = false

    /// The mock user object to return on success.
    var mockUser: User?

    /// Simulates fetching a GitHub user profile.
    func fetchUser(username: String) async throws -> User {
        if shouldThrowError {
            throw GitHubAPIService.APIError.userNotFound
        }
        return mockUser ?? User(
            login: "mockUser",
            avatarURL: "https://example.com",
            name: "Mock User",
            bio: "Test bio",
            publicRepos: 10,
            followers: 100,
            following: 50
        )
    }

    /// Simulates fetching repositories (not needed for this ViewModel).
    func fetchRepositories(username: String) async throws -> [Repository] {
        return []
    }
}

/// A mock implementation of `SearchHistoryLocalRepository` that returns static test data.
final class MockSearchHistoryLocalRepository: SearchHistoryLocalRepository {
    /// Returns a static list of searched users for testing.
    override func fetchRecent() -> [SearchedUser] {
        return [
            SearchedUser(
                login: "testUser",
                avatarURL: "https://avatar.com/test",
                timestamp: Date()
            )
        ]
    }
}
