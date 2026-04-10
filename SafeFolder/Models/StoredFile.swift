import Foundation

struct StoredFile: Identifiable, Codable, Equatable {
    let id: UUID
    var fileName: String
    var fileExtension: String
    var addedAt: Date
    
    init(id: UUID = UUID(), fileName: String, fileExtension: String, addedAt: Date = Date()) {
        self.id = id
        self.fileName = fileName
        self.fileExtension = fileExtension
        self.addedAt = addedAt
    }
}
