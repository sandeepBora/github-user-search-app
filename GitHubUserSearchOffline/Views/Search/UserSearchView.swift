//
//  UserSearchView.swift
//  GitHubUserSearchOffline
//
//  Created by B Sandeep on 17/07/2025.
//

import SwiftUI

/// Main view for searching GitHub users by username.
struct UserSearchView: View {
    @StateObject private var vm = UserSearchViewModel()
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: AppMetrics.spacing) {
                    headerView
                    searchButton
                    errorView
                    if let user = vm.user {
                        userCardView(user)
                    }
                    Spacer()
                }
                .padding(.top)
                .background(AppColor.background.ignoresSafeArea())

                if isLoading {
                    loadingOverlay
                }
            }
        }
    }

    /// Title and search field
    private var headerView: some View {
        VStack(spacing: AppMetrics.spacing) {
            Text(AppStrings.searchTitle)
                .font(.largeTitle.bold())
                .foregroundColor(AppColor.textPrimary)

            TextField(AppStrings.searchPlaceholder, text: $vm.username)
                .padding(.vertical, AppMetrics.textFieldVerticalPadding)
                .padding(.horizontal, AppMetrics.textFieldHorizontalPadding)
                .background(AppColor.card)
                .cornerRadius(AppMetrics.cardCornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: AppMetrics.cardCornerRadius)
                        .stroke(AppColor.primary.opacity(0.6), lineWidth: 1)
                )
                .padding(.horizontal)
        }
    }

    /// The search button
    private var searchButton: some View {
        Button(action: {
            Task {
                isLoading = true
                await vm.search()
                isLoading = false
            }
        }) {
            Text(AppStrings.searchButton)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: AppMetrics.buttonHeight)
                .background(AppColor.primary)
                .foregroundColor(.white)
                .cornerRadius(AppMetrics.cardCornerRadius)
                .contentShape(Rectangle())
        }
        .padding(.horizontal)
    }

    /// Display error message
    private var errorView: some View {
        Group {
            if let error = vm.error {
                Text(error)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
        }
    }

    /// Show searched user card
    private func userCardView(_ user: User) -> some View {
        NavigationLink(destination: UserDetailView(user: user)) {
            HStack(spacing: AppMetrics.spacing) {
                AsyncImage(url: user.avatar_url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: AppMetrics.avatarSize, height: AppMetrics.avatarSize)
                .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(user.login)
                        .font(.headline)
                        .foregroundColor(AppColor.textPrimary)

                    Text(user.bio ?? AppStrings.profileBioUnavailable)
                        .font(.subheadline)
                        .foregroundColor(AppColor.textSecondary)
                        .lineLimit(1)
                }

                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(AppColor.card)
            .cornerRadius(AppMetrics.cardCornerRadius)
            .padding(.horizontal)
        }
    }

    /// Fullscreen loading spinner
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(AppMetrics.spinnerScale)
        }
        .contentShape(Rectangle()) // blocks touches
    }
}
