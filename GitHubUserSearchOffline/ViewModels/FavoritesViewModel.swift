//
//  FavoritesViewModel.swift
//  GitHubUserSearchOffline
//
//  Created by B Sandeep on 17/07/2025.
//

import Foundation
import CoreData

/// ViewModel responsible for managing the list of favorite users.
final class FavoritesViewModel: ObservableObject {
    /// Published list of favorite users.
    @Published var favorites: [SearchedUser] = []

    private let repository: FavoritesLocalRepository

    /// Initializes the ViewModel with a favorites repository.
    /// - Parameter repository: Repository responsible for favorite persistence. Defaults to a new instance.
    init(repository: FavoritesLocalRepository = FavoritesLocalRepository()) {
        self.repository = repository
        fetchFavorites()
    }

    /// Fetches the current list of favorite users from the repository.
    func fetchFavorites() {
        favorites = repository.fetchFavorites()
    }

    /// Adds a user to favorites and updates the list.
    /// - Parameter user: The `SearchedUser` to add as favorite.
    func addToFavorites(user: SearchedUser) {
        repository.saveFavorite(login: user.login, avatarURL: user.avatarURL)
        fetchFavorites()
    }

    /// Removes a user from favorites by login and updates the list.
    /// - Parameter login: The login identifier of the user to remove.
    func removeFromFavorites(login: String) {
        repository.removeFavorite(login: login)
        fetchFavorites()
    }

    /// Checks if a user with the given login is in favorites.
    /// - Parameter login: The login identifier to check.
    /// - Returns: `true` if the user is a favorite, otherwise `false`.
    func isFavorite(login: String) -> Bool {
        favorites.contains(where: { $0.login == login })
    }
}
