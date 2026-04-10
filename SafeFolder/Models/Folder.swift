import Foundation

enum AuthType: String, Codable {
    case password
    case biometric
}

struct Folder: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var isSecure: Bool
    var authType: AuthType?
    var createdAt: Date
    
    init(id: UUID = UUID(), name: String, isSecure: Bool = false, authType: AuthType? = nil, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.isSecure = isSecure
        self.authType = authType
        self.createdAt = createdAt
    }
}
