//
//  SearchHistoryViewModel.swift
//  GitHubUserSearchOffline
//
//  Created by B Sandeep on 17/07/2025.
//

import Foundation

/// ViewModel to expose Core Data search history to the UI.
@MainActor
final class SearchHistoryViewModel: ObservableObject {
    @Published var history: [SearchedUser] = []

    private let repo: SearchHistoryLocalRepository
    private let gitHubService: GitHubAPIProtocol

    /// Initializes the ViewModel with dependencies.
    /// - Parameters:
    ///   - repo: Local search history repository.
    ///   - gitHubService: Service for interacting with GitHub API.
    init(
        repo: SearchHistoryLocalRepository = SearchHistoryLocalRepository(),
        gitHubService: GitHubAPIProtocol = GitHubAPIService()
    ) {
        self.repo = repo
        self.gitHubService = gitHubService
        load()
    }

    /// Loads recent search history from local storage.
    func load() {
        history = repo.fetchRecent()
    }

    /// Fetches the full GitHub profile for a username
    /// - Parameter username: GitHub login
    /// - Returns: Detailed `User` profile
    func fetchUserProfile(username: String) async throws -> User {
        return try await gitHubService.fetchUser(username: username)
    }
}
