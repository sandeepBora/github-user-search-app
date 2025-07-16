//
//  CoreDataManager.swift
//  GitHubUserSearchOffline
//
//  Created by B Sandeep on 17/07/2025.
//

import CoreData

/// Singleton for managing Core Data stack.
class CoreDataManager {
    static let shared = CoreDataManager()

    /// Persistent container loaded with the SearchModel.
    let container: NSPersistentContainer

    /// ViewContext of the app.
    var context: NSManagedObjectContext {
        container.viewContext
    }

    private init() {
        container = NSPersistentContainer(name: "GitHubUserSearchOffline")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData failed: \(error)")
            }
        }
    }

    /// Saves context changes, if any.
    func save() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
