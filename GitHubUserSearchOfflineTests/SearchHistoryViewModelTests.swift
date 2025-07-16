//
//  SearchHistoryViewModelTests.swift
//  GitHubUserSearchOffline
//
//  Created by B Sandeep on 17/07/2025.
//

import XCTest
@testable import GitHubUserSearchOffline

@MainActor
final class SearchHistoryViewModelTests: XCTestCase {
    var vm: SearchHistoryViewModel!

    override func setUp() {
        vm = SearchHistoryViewModel()
    }

    func testFetchUserProfile_success() async throws {
        let user = try await vm.fetchUserProfile(username: "octocat")
        XCTAssertEqual(user.login.lowercased(), "octocat")
    }
}
