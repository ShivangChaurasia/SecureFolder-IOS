import SwiftUI

struct AuthenticationView: View {
    let folder: Folder
    let onUnlock: () -> Void
    
    @StateObject private var viewModel = AuthenticationViewModel()
    @FocusState private var isPasswordFieldFocused: Bool
    
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
            
            if folder.authType == .password {
                SecureField("Enter Password", text: $viewModel.passwordInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isPasswordFieldFocused)
                    .padding(.horizontal, 40)
                
                Button("Unlock") {
                    viewModel.verifyPassword(for: folder.id) { success in
                        if success { onUnlock() }
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.passwordInput.isEmpty)
                
            } else {
                Button(action: {
                    triggerBiometrics()
                }) {
                    HStack {
                        Image(systemName: "faceid")
                        Text("Use Face ID / Touch ID")
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 10)
            }
            
            Spacer()
        }
        .onAppear {
            if folder.authType == .password {
                isPasswordFieldFocused = true
            } else if folder.authType == .biometric {
                triggerBiometrics()
            }
        }
    }
    
    private func triggerBiometrics() {
        viewModel.triggerBiometricAuth { success in
            if success { onUnlock() }
        }
    }
}
