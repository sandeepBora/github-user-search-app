//
//  UserDetailView.swift
//  GitHubUserSearchOffline
//
//  Created by B Sandeep on 17/07/2025.
//

import SwiftUI

/// Displays a full GitHub user profile and their public repositories.
struct UserDetailView: View {
    let user: User
    @StateObject private var favoritesVM = FavoritesViewModel()
    @State private var repositories: [Repository] = []
    @State private var isLoading = true
    @State private var error: String?

    var body: some View {
        ScrollView {
            VStack(spacing: AppMetrics.spacing) {
                avatarView
                bioView
                statsView
                Divider().padding(.vertical, AppMetrics.spacing)
                reposSection
            }
            .padding(AppMetrics.padding)
        }
        .background(AppColor.background.ignoresSafeArea())
        .navigationTitle(AppStrings.profileTitle)
        .navigationBarTitleDisplayMode(.inline)
        .task { await fetchRepos() }
    }

    /// Avatar image + username
    private var avatarView: some View {
        VStack(spacing: AppMetrics.spacing) {
            AsyncImage(url: user.avatar_url) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: AppMetrics.avatarSize * 2, height: AppMetrics.avatarSize * 2)
            .clipShape(Circle())
            .shadow(radius: 6)

            Text(user.login)
                .font(.title.bold())
                .foregroundColor(AppColor.textPrimary)
            FavoriteToggleButton(user: SearchedUser(login: user.login,
                                                        avatarURL: user.avatar_url.absoluteString,
                                                        timestamp: Date()),
                                     viewModel: favoritesVM)
        }
    }

    /// Bio text
    private var bioView: some View {
        Text(user.bio ?? AppStrings.profileBioUnavailable)
            .font(.body)
            .multilineTextAlignment(.center)
            .foregroundColor(AppColor.textSecondary)
            .padding(.horizontal)
    }

    /// Follower / Repo stats
    private var statsView: some View {
        HStack(spacing: AppMetrics.spacing * 2) {
            statItem(count: user.followers, label: AppStrings.profileFollowers)
            statItem(count: user.public_repos, label: AppStrings.profileRepos)
        }
    }

    /// Single stat block
    private func statItem(count: Int, label: String) -> some View {
        VStack {
            Text("\(count)")
                .font(.headline)
                .foregroundColor(AppColor.textPrimary)
            Text(label)
                .font(.caption)
                .foregroundColor(AppColor.textSecondary)
        }
    }

    /// Repositories section
    private var reposSection: some View {
        VStack(alignment: .leading, spacing: AppMetrics.spacing) {
            Text(AppStrings.repoSectionTitle)
                .font(.headline)
                .foregroundColor(AppColor.textPrimary)

            if isLoading {
                ProgressView(AppStrings.loadingRepos)
            } else if let error = error {
                Text("⚠️ \(error)")
                    .foregroundColor(.red)
            } else if repositories.isEmpty {
                Text(AppStrings.noRepos)
                    .foregroundColor(AppColor.textSecondary)
            } else {
                ForEach(repositories) { repo in
                    repoItemView(repo)
                }
            }
        }
    }

    /// Repo card view
    private func repoItemView(_ repo: Repository) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(repo.name)
                .font(.subheadline.bold())
                .foregroundColor(AppColor.textPrimary)

            if let desc = repo.description {
                Text(desc)
                    .font(.caption)
                    .foregroundColor(AppColor.textSecondary)
            }

            HStack(spacing: 16) {
                Label("\(repo.stargazers_count)", systemImage: AppStrings.repoStars)
                Label("\(repo.forks_count)", systemImage: AppStrings.repoForks)
            }
            .font(.caption2)
            .foregroundColor(.gray)

            Divider()
        }
    }

    /// Fetch the user’s repositories
    private func fetchRepos() async {
        do {
            repositories = try await GitHubAPIService().fetchRepositories(username: user.login)
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
}
