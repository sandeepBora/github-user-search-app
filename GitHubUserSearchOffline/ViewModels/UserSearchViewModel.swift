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

    private let api = GitHubAPIService()
    private let history = SearchHistoryLocalRepository()

    func search() async {
        do {
            let fetchedUser = try await api.fetchUser(username: username)
            self.user = fetchedUser
            self.repos = try await api.fetchRepositories(username: username)
            history.save(user: fetchedUser)
            self.error = nil
        } catch {
            self.error = error.localizedDescription
            self.user = nil
            self.repos = []
        }
    }
}
