//
//  UserSearchViewModel.swift
//  GitHubUserSearchOffline
//
//  Created by B Sandeep on 17/07/2025.
//

import Foundation

/// Handles search logic for GitHub user and repos.
@MainActor
class UserSearchViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var user: User?
    @Published var repos: [Repository] = []
    @Published var error: String?

    private let gitHubService: GitHubAPIProtocol
    private let history = SearchHistoryLocalRepository()

    /// Initializes the ViewModel with dependencies.
    /// - Parameters:
    ///   - gitHubService: Service for interacting with GitHub API.
    init(gitHubService: GitHubAPIProtocol = GitHubAPIService()) {
        self.gitHubService = gitHubService
    }
    
    func search() async {
        do {
            let fetchedUser = try await gitHubService.fetchUser(username: username)
            self.user = fetchedUser
            self.repos = try await gitHubService.fetchRepositories(username: username)
            history.save(user: fetchedUser)
            self.error = nil
        } catch {
            self.error = error.localizedDescription
            self.user = nil
            self.repos = []
        }
    }
}
