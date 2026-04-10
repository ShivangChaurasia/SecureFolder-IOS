import SwiftUI

struct CreateFolderView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: FolderListViewModel
    
    @State private var folderName = ""
    @State private var isSecure = false
    @State private var useBiometricAuth = true
    @State private var usePasswordAuth = false
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Folder Details")) {
                    TextField("Folder Name", text: $folderName)
                    Toggle("Secure Folder", isOn: $isSecure)
                }
                
                if isSecure {
                    Section(header: Text("Security Constraints")) {
                        Toggle("Allow Face ID / Touch ID", isOn: $useBiometricAuth)
                        Toggle("Allow Folder Password", isOn: $usePasswordAuth)

                        if usePasswordAuth {
                            SecureField("Create Password", text: $password)
                        }
                    }
                }
            }
            .navigationTitle("New Folder")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        viewModel.createFolder(
                            name: folderName,
                            isSecure: isSecure,
                            allowsBiometricAuth: useBiometricAuth,
                            allowsPasswordAuth: usePasswordAuth,
                            password: usePasswordAuth ? password : nil
                        )
                        dismiss()
                    }
                    .disabled(
                        folderName.isEmpty ||
                        (isSecure && !useBiometricAuth && !usePasswordAuth) ||
                        (isSecure && usePasswordAuth && password.isEmpty)
                    )
                }
            }
        }
    }
}
