import Foundation
import Combine

class AuthenticationViewModel: ObservableObject {
    @Published var passwordInput: String = ""
    @Published var errorMessage: String? = nil
    
    private let biometricService = BiometricService()
    private let securityService = SecurityService.shared
    
    // Call this if the folder has authType == .biometric upon appearing
    func triggerBiometricAuth(completion: @escaping (Bool) -> Void) {
        biometricService.authenticateWithBiometrics { success, errorMsg in
            if success {
                completion(true)
            } else {
                self.errorMessage = errorMsg
                completion(false)
            }
        }
    }
    
    // Call this if authType == .password when the user hits unlock
    func verifyPassword(for folderId: UUID, completion: @escaping (Bool) -> Void) {
        let success = securityService.verifyPassword(passwordInput, forFolderId: folderId)
        if success {
            completion(true)
        } else {
            self.errorMessage = "Incorrect password"
            self.passwordInput = ""
            completion(false)
        }
    }
}
