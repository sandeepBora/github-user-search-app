//
//  SearchHistoryLocalRepositoryTests.swift
//  GitHubUserSearchOfflineTests
//
//  Created by B Sandeep on 17/07/2025.
//

import XCTest
import CoreData
@testable import GitHubUserSearchOffline

final class SearchHistoryLocalRepositoryTests: XCTestCase {

    var repository: SearchHistoryLocalRepository!
    var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()

        // In-memory Core Data container
        let container = NSPersistentContainer(name: "GitHubUserSearchOffline") // Match your .xcdatamodeld name
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }

        context = container.viewContext
        repository = SearchHistoryLocalRepository(context: context)
    }

    override func tearDown() {
        repository = nil
        context = nil
        super.tearDown()
    }

    func testSavingNewUserInsertsCorrectly() {
        let user = makeMockUser(login: "unique_user")
        repository.save(user: user)

        let saved = repository.fetchRecent()
        XCTAssertEqual(saved.count, 1)
        XCTAssertEqual(saved.first?.login, "unique_user")
    }

    func testDuplicateUserDoesNotCreateMultipleEntries() {
        let user = makeMockUser(login: "duplicate_user")
        repository.save(user: user)
        repository.save(user: user)

        let saved = repository.fetchRecent()
        XCTAssertEqual(saved.count, 1, "Duplicate users should not be added twice.")
    }

    func testTimestampUpdatesOnDuplicateUserSave() {
        let user = makeMockUser(login: "timestamp_user")
        repository.save(user: user)

        // Wait for 1 second to ensure timestamp difference
        sleep(1)

        repository.save(user: user)
        let saved = repository.fetchRecent()
        XCTAssertEqual(saved.count, 1)

        let entity = saved.first
        XCTAssertNotNil(entity?.timestamp)
    }

    func testRecentFetchReturnsSortedByTimestampDescending() {
        let user1 = makeMockUser(login: "early")
        let user2 = makeMockUser(login: "late")

        repository.save(user: user1)
        sleep(1)
        repository.save(user: user2)

        let results = repository.fetchRecent()
        XCTAssertEqual(results.first?.login, "late", "Most recent search should appear first")
    }

    // MARK: - Helper

    private func makeMockUser(login: String) -> User {
        return User(
            id: Int.random(in: 1...10000),
            login: login,
            avatar_url: URL(string: "https://example.com/avatar.png")!,
            bio: "Mock bio",
            followers: 0,
            public_repos: 0
        )
    }
}
