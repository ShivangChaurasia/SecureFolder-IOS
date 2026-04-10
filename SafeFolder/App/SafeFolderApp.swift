import SwiftUI

@main
struct SafeFolderApp: App {
    @StateObject private var appEnvironment = AppEnvironment()
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var navigationId = UUID()

    var body: some Scene {
        WindowGroup {
            FolderListView()
                .environmentObject(appEnvironment)
                .id(navigationId)
                .onAppear {
                    appEnvironment.resetAutoLockTimer()
                }
                .onChange(of: appEnvironment.isAppLocked) { isLocked in
                    if isLocked {
                        // Reset navigation by changing ID, popping to root.
                        navigationId = UUID()
                        appEnvironment.isAppLocked = false
                    }
                }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background {
                // Backgrounding triggers an immediate lock navigate back
                appEnvironment.isAppLocked = true
            } else if phase == .active {
                appEnvironment.resetAutoLockTimer()
            }
        }
    }
}
