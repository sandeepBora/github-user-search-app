//
//  GitHubAPIServiceTests.swift
//  GitHubUserSearchOffline
//
//  Created by B Sandeep on 17/07/2025.
//

import XCTest
@testable import GitHubUserSearchOffline

final class GitHubAPIServiceTests: XCTestCase {
    var api: GitHubAPIService!

    override func setUp() {
        super.setUp()

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        api = GitHubAPIService(session: session)
    }

    func testFetchUserSuccess() async throws {
        let userJSON = """
        {
            "login": "octocat",
            "id": 1,
            "avatar_url": "https://github.com/images/error/octocat_happy.gif"
        }
        """
        MockURLProtocol.testData = userJSON.data(using: .utf8)
        MockURLProtocol.response = HTTPURLResponse(url: URL(string: "https://api.github.com/users/octocat")!,
                                                   statusCode: 200, httpVersion: nil, headerFields: nil)

        let user = try await api.fetchUser(username: "octocat")

        XCTAssertEqual(user.login, "octocat")
        XCTAssertEqual(user.avatar_url.absoluteString, "https://github.com/images/error/octocat_happy.gif")
    }

    func testFetchUserFailsWithInvalidStatusCode() async {
        MockURLProtocol.testData = nil
        MockURLProtocol.response = HTTPURLResponse(url: URL(string: "https://api.github.com/users/octocat")!,
                                                   statusCode: 404, httpVersion: nil, headerFields: nil)

        do {
            _ = try await api.fetchUser(username: "octocat")
            XCTFail("Expected error not thrown")
        } catch let error as GitHubAPIService.APIError {
            XCTAssertEqual(error, .userNotFound)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testFetchRepositoriesSuccess() async throws {
        let reposJSON = """
        [
            { "id": 1, "name": "Repo1", "full_name": "octocat/Repo1" },
            { "id": 2, "name": "Repo2", "full_name": "octocat/Repo2" }
        ]
        """
        MockURLProtocol.testData = reposJSON.data(using: .utf8)
        MockURLProtocol.response = HTTPURLResponse(url: URL(string: "https://api.github.com/users/octocat/repos")!,
                                                   statusCode: 200, httpVersion: nil, headerFields: nil)

        let repos = try await api.fetchRepositories(username: "octocat")
        XCTAssertEqual(repos.count, 2)
        XCTAssertEqual(repos.first?.name, "Repo1")
    }
}
