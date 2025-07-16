//
//  SearchHistoryRowView.swift
//  GitHubUserSearchOffline
//
//  Created by M Naveen on 17/07/2025.
//

import SwiftUI

struct SearchHistoryRow: View {
    let user: SearchedUser
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            SearchHistoryCardView(user: user)
        }
        .buttonStyle(PlainButtonStyle())
        .listRowBackground(Color.clear)
    }
}
