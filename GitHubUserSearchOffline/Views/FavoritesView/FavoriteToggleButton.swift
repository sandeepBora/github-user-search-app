//
//  FavoriteToggleButton.swift
//  GitHubUserSearchOffline
//
//  Created by B Sandeep on 17/07/2025.
//
import SwiftUI

struct FavoriteToggleButton: View {
    let user: SearchedUser
    @ObservedObject var viewModel: FavoritesViewModel

    var body: some View {
        Button(action: {
            if viewModel.isFavorite(login: user.login) {
                viewModel.removeFromFavorites(login: user.login)
            } else {
                viewModel.addToFavorites(user: user)
            }
        }) {
            Image(systemName: viewModel.isFavorite(login: user.login) ? "star.fill" : "star")
                .foregroundColor(.yellow)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
