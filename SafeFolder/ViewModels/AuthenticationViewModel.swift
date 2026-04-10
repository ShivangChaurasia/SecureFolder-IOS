import Foundation
import Combine

class AuthenticationViewModel: ObservableObject {
    @Published var passwordInput: String = ""
    @Published var errorMessage: String? = nil
    
    private let biometricService = BiometricService()
    private let securityService = SecurityService.shared
    
    func triggerBiometricAuth(completion: @escaping (Bool) -> Void) {
        biometricService.authenticateWithBiometrics { success, errorMsg in
            if success {
                self.errorMessage = nil
                completion(true)
            } else {
                self.errorMessage = errorMsg
                completion(false)
            }
        }
    }
    
    func verifyPassword(for folderId: UUID, completion: @escaping (Bool) -> Void) {
        let success = securityService.verifyPassword(passwordInput, forFolderId: folderId)
        if success {
            self.errorMessage = nil
            completion(true)
        } else {
            self.errorMessage = "Incorrect password"
            self.passwordInput = ""
            completion(false)
        }
    }
}
