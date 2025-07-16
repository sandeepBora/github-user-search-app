//
//  FavoritesLocalRepository.swift
//  GitHubUserSearchOffline
//
//  Created by B Sandeep on 17/07/2025.
//

import Foundation
import CoreData

/// Repository for managing favorite users in Core Data.
final class FavoritesLocalRepository {
    private let context: NSManagedObjectContext

    /// Initializes the repository with the given Core Data context.
    /// - Parameter context: The managed object context to use. Defaults to `CoreDataManager.shared.context`.
    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }

    /// Fetches all users marked as favorites.
    /// - Returns: An array of `SearchedUser` objects marked as favorite, sorted by timestamp descending.
    func fetchFavorites() -> [SearchedUser] {
        let request: NSFetchRequest<SearchedUserEntity> = SearchedUserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == true")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \SearchedUserEntity.timestamp, ascending: false)]

        do {
            let entities = try context.fetch(request)
            return entities.map {
                SearchedUser(
                    login: $0.login ?? "",
                    avatarURL: $0.avatarURL ?? "",
                    timestamp: $0.timestamp ?? Date()
                )
            }
        } catch {
            print("Failed to fetch favorites: \(error)")
            return []
        }
    }

    /// Saves a user as a favorite in Core Data.
    ///
    /// If a user with the given login already exists, it updates the `isFavorite` flag and timestamp.
    /// Otherwise, it creates a new user entity marked as favorite.
    ///
    /// - Parameters:
    ///   - login: The login identifier of the user.
    ///   - avatarURL: The avatar URL string of the user.
    func saveFavorite(login: String, avatarURL: String) {
        let request: NSFetchRequest<SearchedUserEntity> = SearchedUserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "login == %@", login)
        request.fetchLimit = 1

        do {
            if let existingEntity = try context.fetch(request).first {
                existingEntity.isFavorite = true
                existingEntity.timestamp = Date()
            } else {
                let newEntity = SearchedUserEntity(context: context)
                newEntity.login = login
                newEntity.avatarURL = avatarURL
                newEntity.isFavorite = true
                newEntity.timestamp = Date()
            }
            try context.save()
        } catch {
            print("Failed to save favorite: \(error)")
        }
    }

    /// Removes a user from favorites by setting `isFavorite` to false.
    ///
    /// - Parameter login: The login identifier of the user to remove from favorites.
    func removeFavorite(login: String) {
        let request: NSFetchRequest<SearchedUserEntity> = SearchedUserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "login == %@", login)
        request.fetchLimit = 1

        do {
            if let entity = try context.fetch(request).first {
                entity.isFavorite = false
                try context.save()
            }
        } catch {
            print("Failed to remove favorite: \(error)")
        }
    }
}
