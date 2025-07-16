//
//  UserSearchViewModelTests.swift
//  GitHubUserSearchOffline
//
//  Created by B Sandeep on 17/07/2025.
//

import XCTest
@testable import GitHubUserSearchOffline

@MainActor
final class UserSearchViewModelTests: XCTestCase {
    var vm: UserSearchViewModel!

    override func setUp() {
        vm = UserSearchViewModel()
    }

    func testSearch_successful() async {
        vm.username = "octocat"
        await vm.search()
        XCTAssertEqual(vm.user?.login.lowercased(), "octocat")
        XCTAssertNil(vm.error)
    }

    func testSearch_invalidUser_setsError() async {
        vm.username = "non_existing_user_xyz123456789"
        await vm.search()
        XCTAssertNil(vm.user)
        XCTAssertNotNil(vm.error)
    }

    func testEmptyUsernameDoesNothing() async {
        vm.username = ""
        await vm.search()
        XCTAssertNil(vm.user)
    }
}
