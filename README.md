# 🚀 GitHub User Search App (SwiftUI + MVVM)

This is an iOS application built using **SwiftUI** and **MVVM** architecture. The app allows users to search for GitHub users, view their profile and public repositories, and manage favorite users locally using Core Data.

---

## 📱 Features

- 🔍 Search GitHub users by username
- 👤 View user profile:
  - Avatar
  - Username
  - Bio
  - Followers count
  - Public repositories count
- 📦 Display repositories:
  - Name
  - Description
  - Stars
  - Forks
- 💾 Add/remove favorites (stored locally with Core Data)
- 🗂️ View list of favorite users
- 🔁 Pull-to-refresh support on repository list
- ⚠️ Error handling:
  - Invalid usernames (e.g., "User not found")
  - Network/API failures
- 🌙 Full support for Dark Mode

---

## 🛠️ Tech Stack

- **SwiftUI** for user interface
- **MVVM** (Model-View-ViewModel) architecture
- **URLSession** for API calls
- **Combine** / `@StateObject` / `@ObservedObject` for state management
- **Core Data** for persistent local storage of favorites
- **Image caching** via `URLCache` or third-party like `SDWebImageSwiftUI` *(optional)*

---

## 📂 Project Structure

```
GitHubUserSearch/
│
├── Models/
│   ├── User.swift
│   └── Repository.swift
│
├── ViewModels/
│   ├── SearchViewModel.swift
│   ├── UserDetailViewModel.swift
│   └── FavoritesViewModel.swift
│
├── Views/
│   ├── SearchView.swift
│   ├── UserDetailView.swift
│   ├── RepositoryListView.swift
│   └── FavoritesView.swift
│
├── Services/
│   └── GitHubAPIService.swift
│
├── Persistence/
│   └── FavoritesLocalRepository.swift
│
└── Resources/
    └── Assets.xcassets
```

---

## 🔌 GitHub REST API Used

- **User Profile**
  ```
  GET https://api.github.com/users/{username}
  ```
- **Public Repositories**
  ```
  GET https://api.github.com/users/{username}/repos
  ```

---

## ✅ Getting Started

1. Clone the repo:
   ```bash
   git clone https://github.com/your-username/GitHubUserSearchApp.git
   ```

2. Open the project in Xcode:
   ```bash
   open GitHubUserSearchApp.xcodeproj
   ```

3. Build & run the app on an iOS device or simulator (iOS 15+ recommended)

---

## 🧪 Test Scenarios

- ✅ Search for valid GitHub users (e.g., `octocat`)
- ❌ Invalid search (e.g., `nonexistentuser123`)
- 🔄 Pull to refresh repository list
- 💾 Add/remove favorite users
- 📶 Test with no internet (displays error messages)

---

## ✨ Optional Enhancements (Completed)

- [x] Pull-to-refresh for repository list
- [x] Favorites/bookmarking using Core Data
- [x] Favorites screen UI
- [x] Dark mode support
- [ ] Pagination for repository results
- [ ] Offline caching of previous results

---

## 📸 Screenshots

> You can include screenshots like below:

| Search | Profile | Repositories | Favorites |
|--------|---------|--------------|-----------|
| ![](Screenshots/search.png) | ![](Screenshots/profile.png) | ![](Screenshots/repos.png) | ![](Screenshots/favorites.png) |

---

## 👤 Author

Developed using **SwiftUI + MVVM** by B Sandeep.
