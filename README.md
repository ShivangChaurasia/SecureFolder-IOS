# 🔒 Safe Folder iOS App

> A secure, SwiftUI-based iOS application that allows users to create folders and securely store files with biometric and password protection.

---

## 📖 Project Overview

**Safe Folder** is an elegant, privacy-first iOS application designed to help users organize and securely store their sensitive files. Built entirely with **SwiftUI** and using an **MVVM architecture**, this app demonstrates modern iOS development practices while taking advantage of local, on-device storage.

The app supports both standard (non-secure) folders for everyday files and secure folders that require authentication (Password, Face ID, or Touch ID) before granting access. By utilizing the `FileManager` for local storage and `Keychain` for sensitive credentials, the app ensures zero external dependencies or network tracking for maximum user privacy.

---

## ✨ Features

- **Folder Management**: Create, delete, and manage both secure and non-secure folders.
- **Convert Folders**: Seamlessly convert folders back and forth between secure and non-secure states.
- **Robust Security**:
  - **Biometric Authentication**: Integration with `LocalAuthentication` for Face ID & Touch ID.
  - **Keychain Storage**: Cryptographically secure storage for folder passwords.
  - **Auto-Lock Mechanism**: Folders automatically lock after 15 seconds of inactivity.
  - **App Lifecycle Awareness**: Secure folders lock instantly when the app goes into the background.
- **File Management**:
  - Import securely via Camera, Photo Library, and native Files app (Document Picker).
  - Support for images, PDFs, and standard file documents.
- **Intuitive UI**:
  - **Grid/List Views**: Toggle between visual grid thumbnails and detailed list views.
  - Smart thumbnail generation for images and generic icons for documents.

---

## 🛠 Tech Stack

- **Framework**: SwiftUI
- **Architecture**: MVVM (Model-View-ViewModel)
- **Language**: Swift / Swift 5+
- **Security**: LocalAuthentication (Face ID/Touch ID), Keychain Services (via wrapper)
- **Storage**: FileManager (Document Directory), JSON encoding for metadata (no third-party DB)
- **Minimum Deployment Target**: iOS 15.0+ (or 16.0+, depending on project config)

---

## 🏗 Architecture & Structural Approach

This project strictly adheres to the **MVVM (Model-View-ViewModel)** architectural pattern to separate business logic from the user interface, improving testability and code maintainability.

### Suggested Folder Structure

A well-organized structure keeps the project scalable. Here is how the project files should be arranged:

```text
SafeFolder/
├── App/                       # App Entry Point, Delegates, and App State
│   ├── SafeFolderApp.swift
│   └── AppEnvironment.swift   # Global modifiers or states (e.g., auto-lock timer)
├── Models/                    # Data Structures and Entities
│   ├── Folder.swift           # Folder entity (id, name, isSecure, etc.)
│   └── StoredFile.swift       # File reference entity 
├── Views/                     # SwiftUI Views grouped by feature
│   ├── Main/
│   │   └── FolderListView.swift
│   ├── FolderDetail/
│   │   ├── FolderDetailView.swift
│   │   └── FileGridView.swift
│   └── Components/            # Reusable UI components
│       ├── AuthenticationView.swift
│       └── FileThumbnailView.swift
├── ViewModels/                # Business logic and state management
│   ├── FolderListViewModel.swift
│   ├── FolderDetailViewModel.swift
│   └── AuthenticationViewModel.swift
├── Services/                  # Modular services providing specific utility
│   ├── StorageService.swift   # FileManager interactions and JSON mapping
│   ├── SecurityService.swift  # Keychain wrapper and password management
│   └── BiometricService.swift # LocalAuthentication (Face ID / Touch ID) logic
├── Resources/                 # Assets, Info.plist, Localization
│   └── Assets.xcassets
└── Utilities/                 # Extensions and helper methods
    ├── Extensions/
    └── Constants.swift
```

- **Models**: Defines the data layer structures (`Folder`, `StoredFile`).
- **ViewModels**: Handles the UI state, user actions, and communicates with Services.
- **Views**: Declarative UI components observing ViewModels.
- **Services**: Abstracted managers handling persistence (FileManager) and security (Keychain & Biometrics).

---

## 🚀 Setup Instructions

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/SafeFolder-iOS.git
   cd SafeFolder-iOS
   ```
2. **Open the project in Xcode:**
   ```bash
   open SafeFolder.xcodeproj
   ```
3. **Configure Code Signing:**
   - Go to the project settings > **Signing & Capabilities**.
   - Select your valid iOS Development team.
4. **Run the App:**
   - Select an iOS Simulator or a physical device.
   - Press `Cmd + R` to build and run.
   > **Note:** To test the Camera functionality and Face ID, you will need to run the application on a physical iOS device.

---

## 🎯 Future Improvements

- **Cloud Backup**: Optional, opt-in secure iCloud syncing.
- **Custom App Icons**: Let users choose different application icons for privacy.
- **Decoy Mode**: Implement a fake passcode that opens a dummy folder layout for plausible deniability.
- **Built-in Document Scanner**: Native PDF scanning integration using `VisionKit`.
- **Unit and UI Tests**: Increase test coverage for ViewModel logic and Security interactions.

---

## 👨‍💻 Developer Skills Demonstrated

- **SwiftUI Mastery**: Utilizing the latest declarative syntax, ViewModifiers, and property wrappers (`@StateObject`, `@Published`, `@Environment`).
- **Security Best Practices**: Real-world application of Apple's security frameworks (Keychain & biometrics) rather than relying on UserDefaults for sensitive data.
- **Clean Architecture**: Strong adherence to SOLID principles, dependency injection in ViewModels, and single-responsibility services.
- **App Lifecycle Handling**: Implementing `ScenePhase` observers to execute business logic (app locking) upon backgrounding.

---
*If you are a recruiter or an engineering manager reviewing this project, feel free to reach out to me for a walkthrough of the architecture and design decisions.*
