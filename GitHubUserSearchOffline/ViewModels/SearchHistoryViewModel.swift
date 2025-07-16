//
//  SearchHistoryViewModel.swift
//  GitHubUserSearchOffline
//
//  Created by B Sandeep on 17/07/2025.
//

import Foundation

/// ViewModel to expose Core Data search history to the UI.
@MainActor
class SearchHistoryViewModel: ObservableObject {
    @Published var history: [SearchedUser] = []

    private let repo = SearchHistoryLocalRepository()
    private let api = GitHubAPIService()

    func load() {
        history = repo.fetchRecent()
    }

    /// Fetches the full GitHub profile for a username
    func fetchUserProfile(username: String) async throws -> User {
        return try await api.fetchUser(username: username)
    }
}
