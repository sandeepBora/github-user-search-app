//
//  FavoritesView.swift
//  GitHubUserSearchOffline
//
//  Created by B Sandeep on 17/07/2025.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var favoritesVM = FavoritesViewModel()
    @StateObject private var vm = SearchHistoryViewModel()

    @State private var selectedUser: User?
    @State private var isShowingDetail = false
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            List {
                ForEach(favoritesVM.favorites) { user in
                    FavoriteUserRow(
                        user: user,
                        onSelect: { fetchUserDetail(for: user.login) }
                    )
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Favorites")
            .background(AppColor.background)
            .navigationDestination(isPresented: $isShowingDetail) {
                if let user = selectedUser {
                    UserDetailView(user: user)
                }
            }
            .onAppear {
                favoritesVM.fetchFavorites()
            }
            .alert("Error", isPresented: .constant(errorMessage != nil)) {
                Button("OK", role: .cancel) { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }

    private func fetchUserDetail(for login: String) {
        Task {
            isLoading = true
            defer { isLoading = false }

            do {
                let user = try await vm.fetchUserProfile(username: login)
                selectedUser = user
                isShowingDetail = true
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}

/// A reusable row view representing a favorite user.
private struct FavoriteUserRow: View {
    let user: SearchedUser
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            SearchHistoryCardView(user: user)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
