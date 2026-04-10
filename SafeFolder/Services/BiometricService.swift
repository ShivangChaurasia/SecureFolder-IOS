import Foundation
import LocalAuthentication

class BiometricService {
    enum BiometricType {
        case faceID
        case touchID
        case none
    }

    func biometricType() -> BiometricType {
        let context = LAContext()
        var error: NSError?

        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)

        switch context.biometryType {
        case .faceID:
            return .faceID
        case .touchID:
            return .touchID
        default:
            return .none
        }
    }

    func availabilityMessage() -> String? {
        let context = LAContext()
        var error: NSError?

        guard !context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return nil
        }

        guard let laError = error as? LAError else {
            return error?.localizedDescription ?? "Authentication is unavailable on this device."
        }

        switch laError.code {
        case .biometryNotEnrolled:
            return "Face ID or Touch ID is available, but no biometric is enrolled on this device."
        case .biometryNotAvailable:
            #if targetEnvironment(simulator)
            return "Biometric authentication is not enabled in the Simulator. Enable Face ID or Touch ID in the Simulator features menu, or run the app on a real device."
            #else
            return "Face ID or Touch ID is not available on this device."
            #endif
        case .passcodeNotSet:
            return "Device passcode is not set. Set a device passcode to use Face ID or Touch ID authentication."
        default:
            return laError.localizedDescription
        }
    }

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
                completion(false, self.availabilityMessage() ?? error?.localizedDescription ?? "Authentication is unavailable on this device.")
            }
        }
    }
}
