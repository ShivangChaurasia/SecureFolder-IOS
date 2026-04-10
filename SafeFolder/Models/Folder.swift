import Foundation

enum AuthType: String, Codable {
    case password
    case biometric
}

struct Folder: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var name: String
    var isSecure: Bool
    var allowsBiometricAuth: Bool
    var allowsPasswordAuth: Bool
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        isSecure: Bool = false,
        allowsBiometricAuth: Bool = false,
        allowsPasswordAuth: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.isSecure = isSecure
        self.allowsBiometricAuth = allowsBiometricAuth
        self.allowsPasswordAuth = allowsPasswordAuth
        self.createdAt = createdAt
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case isSecure
        case allowsBiometricAuth
        case allowsPasswordAuth
        case createdAt
        case authType
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        isSecure = try container.decode(Bool.self, forKey: .isSecure)
        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt) ?? Date()

        let allowsBiometricAuth = try container.decodeIfPresent(Bool.self, forKey: .allowsBiometricAuth)
        let allowsPasswordAuth = try container.decodeIfPresent(Bool.self, forKey: .allowsPasswordAuth)
        let legacyAuthType = try container.decodeIfPresent(AuthType.self, forKey: .authType)

        self.allowsBiometricAuth = allowsBiometricAuth ?? (legacyAuthType == .biometric)
        self.allowsPasswordAuth = allowsPasswordAuth ?? (legacyAuthType == .password)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(isSecure, forKey: .isSecure)
        try container.encode(allowsBiometricAuth, forKey: .allowsBiometricAuth)
        try container.encode(allowsPasswordAuth, forKey: .allowsPasswordAuth)
        try container.encode(createdAt, forKey: .createdAt)
    }
}
