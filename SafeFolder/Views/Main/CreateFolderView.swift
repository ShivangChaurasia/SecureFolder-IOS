import SwiftUI

struct CreateFolderView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: FolderListViewModel
    
    @State private var folderName = ""
    @State private var isSecure = false
    @State private var authType: AuthType = .biometric
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
                        Picker("Authentication Method", selection: $authType) {
                            Text("Face ID / Touch ID").tag(AuthType.biometric)
                            Text("Custom Password").tag(AuthType.password)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        if authType == .password {
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
                        if isSecure && authType == .password {
                            viewModel.createFolder(name: folderName, isSecure: true, authType: .password, password: password)
                        } else if isSecure {
                            viewModel.createFolder(name: folderName, isSecure: true, authType: .biometric, password: nil)
                        } else {
                            viewModel.createFolder(name: folderName, isSecure: false, authType: nil, password: nil)
                        }
                        dismiss()
                    }
                    .disabled(folderName.isEmpty || (isSecure && authType == .password && password.isEmpty))
                }
            }
        }
    }
}
