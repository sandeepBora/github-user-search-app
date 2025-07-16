//
//  GitHubAPIServiceTests.swift
//  GitHubUserSearchOffline
//
//  Created by B Sandeep on 17/07/2025.
//

import XCTest
@testable import GitHubUserSearchOffline

final class GitHubAPIServiceTests: XCTestCase {
    var service: GitHubAPIService!

    override func setUp() {
        service = GitHubAPIService()
    }

    func testFetchUser_success() async throws {
        let user = try await service.fetchUser(username: "octocat")
        XCTAssertEqual(user.login.lowercased(), "octocat")
    }

    func testFetchUser_invalidUsername_throws() async {
        do {
            _ = try await service.fetchUser(username: "this_user_should_not_exist_999999")
            XCTFail("Expected to throw error")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func testFetchRepositories_success() async throws {
        let repos = try await service.fetchRepositories(username: "apple")
        XCTAssertGreaterThan(repos.count, 0)
    }
}
