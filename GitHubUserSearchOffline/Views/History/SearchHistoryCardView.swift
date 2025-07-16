//
//  SearchHistoryCardView.swift
//  GitHubUserSearchOffline
//
//  Created by B Sandeep on 17/07/2025.
//

import SwiftUI

/// A reusable row view for search history list.
struct SearchHistoryCardView: View {
    let user: SearchedUser
    @StateObject var favoritesVM: FavoritesViewModel = FavoritesViewModel()

    var body: some View {
        HStack(spacing: AppMetrics.spacing) {
            AsyncImage(url: URL(string: user.avatarURL)) { image in
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
                    .accessibilityLabel("User: \(user.login)")

                Text(user.timestamp, style: .relative)
                    .font(.caption)
                    .foregroundColor(AppColor.textSecondary)
            }

            Spacer()

            FavoriteToggleButton(user: user, viewModel: favoritesVM)
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(AppColor.card)
        .cornerRadius(AppMetrics.cardCornerRadius)
    }
}
