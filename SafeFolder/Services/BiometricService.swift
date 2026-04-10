import Foundation
import LocalAuthentication

class BiometricService {
    func authenticateWithBiometrics(completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Unlock to access your secure folder"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, evaluationError in
                DispatchQueue.main.async {
                    if success {
                        completion(true, nil)
                    } else {
                        completion(false, evaluationError?.localizedDescription ?? "Authentication failed.")
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                completion(false, "Biometrics not available or configured.")
            }
        }
    }
}
