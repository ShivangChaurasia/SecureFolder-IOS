import Foundation
import Combine
import SwiftUI

class AppEnvironment: ObservableObject {
    @Published var isAppLocked: Bool = false
    
    private var inactivityTimer: Timer?
    private let autoLockTimeout: TimeInterval = 15.0
    
    func resetAutoLockTimer() {
        inactivityTimer?.invalidate()
        inactivityTimer = Timer.scheduledTimer(withTimeInterval: autoLockTimeout, repeats: false) { [weak self] _ in
            DispatchQueue.main.async {
                self?.isAppLocked = true
            }
        }
    }
    
    func cancelTimer() {
        inactivityTimer?.invalidate()
    }
}
