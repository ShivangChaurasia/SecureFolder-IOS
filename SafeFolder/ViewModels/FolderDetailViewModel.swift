import Foundation
import Combine
import UIKit

class FolderDetailViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var files: [StoredFile] = []
    
    let folder: Folder
    private let storageService = StorageService.shared
    private var autoLockTimer: Timer?
    
    init(folder: Folder) {
        self.folder = folder
    }
    
    func authenticateIfNeeded() {
        if !folder.isSecure {
            isAuthenticated = true
            loadFiles()
        } else {
            lockFolder()
        }
    }

    func unlockFolder() {
        isAuthenticated = true
        loadFiles()
        resetAutoLockTimer()
    }

    func lockFolder() {
        autoLockTimer?.invalidate()
        isAuthenticated = false
    }
    
    func loadFiles() {
        guard isAuthenticated else { return }
        files = storageService.loadFilesMetadata(for: folder.id)
    }
    
    func addImageFile(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        saveFile(data: data, extensionString: "jpeg", originalName: "Photo-\((Int(Date().timeIntervalSince1970)))")
    }
    
    func addDocumentFile(from url: URL) {
        guard let data = try? Data(contentsOf: url) else { return }
        saveFile(data: data, extensionString: url.pathExtension, originalName: url.deletingPathExtension().lastPathComponent)
    }
    
    private func saveFile(data: Data, extensionString: String, originalName: String) {
        let newFile = StoredFile(fileName: originalName, fileExtension: extensionString)
        
        let success = storageService.saveFile(data: data, folderId: folder.id, fileId: newFile.id, ext: extensionString)
        if success {
            files.append(newFile)
            storageService.saveFilesMetadata(files, for: folder.id)
            resetAutoLockTimer()
        }
    }
    
    func getFileURL(for file: StoredFile) -> URL {
        return storageService.getFileURL(folderId: folder.id, fileId: file.id, ext: file.fileExtension)
    }

    func resetAutoLockTimer() {
        guard folder.isSecure, isAuthenticated else { return }

        autoLockTimer?.invalidate()
        autoLockTimer = Timer.scheduledTimer(withTimeInterval: Constants.Security.autoLockTimeout, repeats: false) { [weak self] _ in
            DispatchQueue.main.async {
                self?.lockFolder()
            }
        }
    }

    func cancelAutoLockTimer() {
        autoLockTimer?.invalidate()
    }

    deinit {
        autoLockTimer?.invalidate()
    }
}
