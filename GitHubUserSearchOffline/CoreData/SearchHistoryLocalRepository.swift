//
//  SearchHistoryLocalRepository.swift
//  GitHubUserSearchOffline
//
//  Created by B Sandeep on 17/07/2025.
//

import CoreData

/// A local repository for storing and retrieving GitHub user search history using Core Data.
class SearchHistoryLocalRepository {
    /// Core Data context from the shared manager.
    private let context: NSManagedObjectContext
    
    /// Default init uses shared context
    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }
    
    /// Saves a GitHub user to Core Data if not already stored.
    ///
    /// - Parameter user: The GitHub user to store in history.
    func save(user: User) {
        if let existing = fetchExistingUser(username: user.login) {
            existing.timestamp = Date()
        } else {
            let entity = SearchedUserEntity(context: context)
            entity.login = user.login
            entity.avatarURL = user.avatar_url.absoluteString
            entity.timestamp = Date()
        }
        
        CoreDataManager.shared.save()
    }
    
    
    /// Fetches a matching `SearchedUserEntity` for a given username if it exists.
    ///
    /// - Parameter username: GitHub username to look for.
    /// - Returns: A matching `SearchedUserEntity` or `nil` if not found.
    private func fetchExistingUser(username: String) -> SearchedUserEntity? {
        let request: NSFetchRequest<SearchedUserEntity> = SearchedUserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "login ==[c] %@", username)
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch {
            print("Error checking for existing user: \(error)")
            return nil
        }
    }
    
    /// Fetches the most recent GitHub user searches stored in Core Data.
    ///
    /// - Returns: An array of `SearchedUser` used for display.
    func fetchRecent() -> [SearchedUser] {
        let request: NSFetchRequest<SearchedUserEntity> = SearchedUserEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \SearchedUserEntity.timestamp, ascending: false)
        ]
        request.fetchLimit = 20
        
        do {
            let results = try context.fetch(request)
            return results.map {
                SearchedUser(
                    login: $0.login ?? "",
                    avatarURL: $0.avatarURL ?? "",
                    timestamp: $0.timestamp ?? Date()
                )
            }
        } catch {
            print("Error fetching recent searches: \(error)")
            return []
        }
    }
    
    /// Deletes all stored search history from Core Data.
    func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = SearchedUserEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            CoreDataManager.shared.save()
        } catch {
            print("Failed to delete search history: \(error)")
        }
    }
}
