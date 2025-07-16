//
//  AppColor.swift
//  GitHubUserSearchOffline
//
//  Created by B Sandeep on 17/07/2025.
//

import SwiftUI

/// Centralized theme color definitions
enum AppColor {
    /// Primary accent color used for buttons, highlights
    static let primary = Color("ThemePrimary")

    /// Background color used throughout views
    static let background = Color("ThemeBackground")

    /// Primary text color for titles and important labels
    static let textPrimary = Color("ThemeText")

    /// Secondary text color for descriptions
    static let textSecondary = Color.secondary

    /// Custom card background (optional)
    static let card = Color(.secondarySystemBackground)
    
    static let tabBackground = Color("TabBackgroundColor")
}
