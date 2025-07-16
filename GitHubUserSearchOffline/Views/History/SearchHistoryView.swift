//
//  SearchHistoryView.swift
//  GitHubUserSearchOffline
//
//  Created by B Sandeep on 17/07/2025.
//

import SwiftUI

/// Displays recent GitHub users searched, stored locally using Core Data.
struct SearchHistoryView: View {
    @StateObject private var vm = SearchHistoryViewModel()

    @State private var selectedUser: User?
    @State private var isShowingDetail = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var searchText: String = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.history) { historyUser in
                    SearchHistoryRow(
                        user: historyUser,
                        onTap: { fetchUserDetail(for: historyUser.login) }
                    )
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchText, prompt: "Search usernames") {
                ForEach(
                    vm.history.filter { $0.login.localizedCaseInsensitiveContains(searchText) }
                        .prefix(5)
                ) { user in
                    Text(user.login)
                        .searchCompletion(user.login)
                }
            }
            .refreshable {
                vm.load()
            }
            .background(AppColor.background)
            .overlay {
                if isLoading {
                    ProgressView(AppStrings.historyLoading)
                        .padding()
                        .background(AppColor.card)
                        .cornerRadius(AppMetrics.cardCornerRadius)
                }
            }
            .navigationTitle("Search History")
            .navigationDestination(isPresented: $isShowingDetail) {
                if let user = selectedUser {
                    UserDetailView(user: user)
                }
            }
            .alert(AppStrings.historyErrorTitle, isPresented: .constant(errorMessage != nil)) {
                Button(AppStrings.historyErrorOK, role: .cancel) {
                    errorMessage = nil
                }
            } message: {
                Text(errorMessage ?? "")
            }
            .task {
                vm.load()
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
