import SwiftUI

struct AuthenticationView: View {
    let folder: Folder
    let onUnlock: () -> Void
    
    @StateObject private var viewModel = AuthenticationViewModel()
    @FocusState private var isPasswordFieldFocused: Bool
    private let biometricService = BiometricService()
    private var biometricAvailabilityMessage: String? {
        biometricService.availabilityMessage()
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 80))
                .foregroundColor(.accentColor)
                .padding(.top, 40)
            
            Text("Folder is Locked")
                .font(.title2)
                .bold()
            
            if let errorMsg = viewModel.errorMessage {
                Text(errorMsg)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            if folder.allowsPasswordAuth {
                SecureField("Enter Password", text: $viewModel.passwordInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isPasswordFieldFocused)
                    .padding(.horizontal, 40)
                
                Button("Unlock With Password") {
                    viewModel.verifyPassword(for: folder.id) { success in
                        if success { onUnlock() }
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.passwordInput.isEmpty)
            }

            if folder.allowsBiometricAuth {
                VStack(spacing: 12) {
                    Button(action: {
                        triggerBiometrics()
                    }) {
                        HStack {
                            Image(systemName: biometricIconName)
                            Text(biometricButtonTitle)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.top, 10)

                if let biometricAvailabilityMessage {
                    Text(biometricAvailabilityMessage)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
            }
            
            Spacer()
        }
        .onAppear {
            if folder.allowsPasswordAuth && !folder.allowsBiometricAuth {
                isPasswordFieldFocused = true
            } else if folder.allowsBiometricAuth {
                triggerBiometrics()
            }
        }
    }
    
    private func triggerBiometrics() {
        viewModel.triggerBiometricAuth { success in
            if success { onUnlock() }
        }
    }

    private var biometricIconName: String {
        switch biometricService.biometricType() {
        case .faceID:
            return "faceid"
        case .touchID:
            return "touchid"
        case .none:
            return "lock.shield"
        }
    }

    private var biometricButtonTitle: String {
        switch biometricService.biometricType() {
        case .faceID:
            return "Use Face ID"
        case .touchID:
            return "Use Touch ID"
        case .none:
            return "Use Biometrics"
        }
    }
}
