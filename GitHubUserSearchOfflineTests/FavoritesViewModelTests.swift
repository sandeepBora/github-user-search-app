//
//  FavoritesViewModelTests.swift
//  GitHubUserSearchOffline
//
//  Created by B Sandeep on 17/07/2025.
//

import XCTest
@testable import GitHubUserSearchOffline

final class MockFavoritesRepository: FavoritesRepositoryProtocol {
    var storage: [SearchedUser] = []

    func fetchFavorites() -> [SearchedUser] {
        return storage
    }

    func saveFavorite(login: String, avatarURL: String) {
        let user = SearchedUser(login: login, avatarURL: avatarURL, timestamp: Date())
        if !storage.contains(where: { $0.login == login }) {
            storage.append(user)
        }
    }

    func removeFavorite(login: String) {
        storage.removeAll { $0.login == login }
    }
}

final class FavoritesViewModelTests: XCTestCase {

    var viewModel: FavoritesViewModel!
    var mockRepo: MockFavoritesRepository!

    override func setUp() {
        super.setUp()
        mockRepo = MockFavoritesRepository()
        viewModel = FavoritesViewModel(repository: mockRepo)
    }

    func testAddToFavorites() {
        let user = SearchedUser(login: "john", avatarURL: "url", timestamp: Date())
        viewModel.addToFavorites(user: user)

        XCTAssertTrue(viewModel.isFavorite(login: "john"))
        XCTAssertEqual(viewModel.favorites.count, 1)
    }

    func testRemoveFromFavorites() {
        let user = SearchedUser(login: "john", avatarURL: "url", timestamp: Date())
        mockRepo.storage = [user]
        viewModel.fetchFavorites()

        viewModel.removeFromFavorites(login: "john")

        XCTAssertFalse(viewModel.isFavorite(login: "john"))
        XCTAssertEqual(viewModel.favorites.count, 0)
    }

    func testFetchFavorites() {
        let user = SearchedUser(login: "alice", avatarURL: "url", timestamp: Date())
        mockRepo.storage = [user]

        viewModel.fetchFavorites()

        XCTAssertEqual(viewModel.favorites.count, 1)
        XCTAssertEqual(viewModel.favorites.first?.login, "alice")
    }

    func testIsFavorite() {
        let user = SearchedUser(login: "bob", avatarURL: "url", timestamp: Date())
        mockRepo.storage = [user]
        viewModel.fetchFavorites()

        XCTAssertTrue(viewModel.isFavorite(login: "bob"))
        XCTAssertFalse(viewModel.isFavorite(login: "someone_else"))
    }
}
