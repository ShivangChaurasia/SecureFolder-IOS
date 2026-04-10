import Foundation
import Combine

class FolderListViewModel: ObservableObject {
    @Published var folders: [Folder] = []
    
    private let storageService = StorageService.shared
    private let securityService = SecurityService.shared
    
    init() {
        folders = storageService.loadFolders()
    }
    
    func createFolder(
        name: String,
        isSecure: Bool,
        allowsBiometricAuth: Bool,
        allowsPasswordAuth: Bool,
        password: String?
    ) {
        let newFolder = Folder(
            name: name,
            isSecure: isSecure,
            allowsBiometricAuth: isSecure && allowsBiometricAuth,
            allowsPasswordAuth: isSecure && allowsPasswordAuth
        )
        
        if isSecure && allowsPasswordAuth, let pwd = password {
            _ = securityService.savePassword(pwd, forFolderId: newFolder.id)
        }
        
        folders.append(newFolder)
        storageService.saveFolders(folders)
    }
    
    func deleteFolder(at offsets: IndexSet) {
        for index in offsets {
            let folder = folders[index]
            storageService.deleteFolderDirectory(for: folder.id)
            if folder.isSecure && folder.allowsPasswordAuth {
                securityService.deletePassword(forFolderId: folder.id)
            }
        }
        folders.remove(atOffsets: offsets)
        storageService.saveFolders(folders)
    }
    
    func toggleSecurity(for folder: Folder) {
        if let index = folders.firstIndex(where: { $0.id == folder.id }) {
            folders[index].isSecure.toggle()
            if folders[index].isSecure {
                folders[index].allowsBiometricAuth = true
                folders[index].allowsPasswordAuth = false
            } else {
                folders[index].allowsBiometricAuth = false
                folders[index].allowsPasswordAuth = false
                securityService.deletePassword(forFolderId: folder.id)
            }
            storageService.saveFolders(folders)
        }
    }
}
