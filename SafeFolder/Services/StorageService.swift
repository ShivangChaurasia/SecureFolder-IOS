import Foundation

class StorageService {
    static let shared = StorageService()
    
    private let fileManager = FileManager.default
    private let foldersFileName = "folders.json"
    
    private var documentDirectory: URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    private var foldersURL: URL {
        return documentDirectory.appendingPathComponent(foldersFileName)
    }
    
    private init() {}
    
    // MARK: - Folder Metadata
    func loadFolders() -> [Folder] {
        guard let data = try? Data(contentsOf: foldersURL) else { return [] }
        let decoder = JSONDecoder()
        return (try? decoder.decode([Folder].self, from: data)) ?? []
    }
    
    func saveFolders(_ folders: [Folder]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(folders) {
            try? data.write(to: foldersURL)
        }
    }
    
    // MARK: - Physical Files
    func getFolderURL(for folderId: UUID) -> URL {
        let folderURL = documentDirectory.appendingPathComponent(folderId.uuidString)
        if !fileManager.fileExists(atPath: folderURL.path) {
            try? fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
        }
        return folderURL
    }
    
    func saveFile(data: Data, folderId: UUID, fileId: UUID, ext: String) -> Bool {
        let folderURL = getFolderURL(for: folderId)
        let fileURL = folderURL.appendingPathComponent("\(fileId.uuidString).\(ext)")
        do {
            try data.write(to: fileURL)
            return true
        } catch {
            print("Error saving file: \(error)")
            return false
        }
    }
    
    func loadFilesMetadata(for folderId: UUID) -> [StoredFile] {
        let folderURL = getFolderURL(for: folderId)
        let metadataURL = folderURL.appendingPathComponent("metadata.json")
        guard let data = try? Data(contentsOf: metadataURL) else { return [] }
        let decoder = JSONDecoder()
        return (try? decoder.decode([StoredFile].self, from: data)) ?? []
    }
    
    func saveFilesMetadata(_ files: [StoredFile], for folderId: UUID) {
        let folderURL = getFolderURL(for: folderId)
        let metadataURL = folderURL.appendingPathComponent("metadata.json")
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(files) {
            try? data.write(to: metadataURL)
        }
    }
    
    func deleteFile(folderId: UUID, fileId: UUID, ext: String) {
        let folderURL = getFolderURL(for: folderId)
        let fileURL = folderURL.appendingPathComponent("\(fileId.uuidString).\(ext)")
        try? fileManager.removeItem(at: fileURL)
    }
    
    func deleteFolderDirectory(for folderId: UUID) {
        let folderURL = documentDirectory.appendingPathComponent(folderId.uuidString)
        try? fileManager.removeItem(at: folderURL)
    }
    
    func getFileURL(folderId: UUID, fileId: UUID, ext: String) -> URL {
        let folderURL = getFolderURL(for: folderId)
        return folderURL.appendingPathComponent("\(fileId.uuidString).\(ext)")
    }
}
