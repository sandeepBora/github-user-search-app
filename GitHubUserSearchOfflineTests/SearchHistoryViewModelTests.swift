//
//  SearchHistoryViewModelTests.swift
//  GitHubUserSearchOffline
//
//  Created by B Sandeep on 17/07/2025.
//

import XCTest
@testable import GitHubUserSearchOffline

/// Unit tests for `SearchHistoryViewModel`, using mock dependencies.
@MainActor
final class SearchHistoryViewModelTests: XCTestCase {
    var mockGitHubService: MockGitHubAPIService!
    var mockRepo: MockSearchHistoryLocalRepository!
    var viewModel: SearchHistoryViewModel!

    /// Sets up mock services and initializes the ViewModel.
    override func setUp() {
        super.setUp()
        mockGitHubService = MockGitHubAPIService()
        mockRepo = MockSearchHistoryLocalRepository()
        viewModel = SearchHistoryViewModel(repo: mockRepo, gitHubService: mockGitHubService)
    }

    /// Tests that the `.load()` method correctly fetches recent history.
    func testLoadFetchesHistory() {
        viewModel.load()

        XCTAssertEqual(viewModel.history.count, 1)
        XCTAssertEqual(viewModel.history.first?.login, "testUser")
    }

    /// Tests that `fetchUserProfile()` returns a valid user on success.
    func testFetchUserProfileSuccess() async throws {
        let expectedUser = User(
            id: 1,
            login: "octocat",
            avatar_url: URL(string: "https://github.com/octocat.png")!,
            bio: "Mascot",
            followers: 50,
            public_repos: 5
        )

        mockGitHubService.mockUser = expectedUser

        let user = try await viewModel.fetchUserProfile(username: "octocat")

        XCTAssertEqual(user.login, expectedUser.login)
        XCTAssertEqual(user.bio, expectedUser.bio)
        XCTAssertEqual(user.followers, expectedUser.followers)
    }

    /// Tests that `fetchUserProfile()` throws an error when the API fails.
    func testFetchUserProfileFailure() async {
        mockGitHubService.shouldThrowError = true

        do {
            _ = try await viewModel.fetchUserProfile(username: "doesNotExist")
            XCTFail("Expected an error to be thrown, but it was not.")
        } catch let error as GitHubAPIService.APIError {
            XCTAssertEqual(error, .userNotFound)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
