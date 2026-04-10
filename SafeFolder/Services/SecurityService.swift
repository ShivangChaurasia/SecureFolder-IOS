import Foundation
import Security

class SecurityService {
    static let shared = SecurityService()
    
    private init() {}
    
    func savePassword(_ password: String, forFolderId folderId: UUID) -> Bool {
        guard let passwordData = password.data(using: .utf8) else { return false }
        
        // Remove existing item to ensure fresh save
        let queryDelete: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: folderId.uuidString
        ]
        SecItemDelete(queryDelete as CFDictionary)
        
        let queryAdd: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: folderId.uuidString,
            kSecValueData as String: passwordData
        ]
        
        let status = SecItemAdd(queryAdd as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func verifyPassword(_ password: String, forFolderId folderId: UUID) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: folderId.uuidString,
            kSecReturnData as String: true
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let storedData = dataTypeRef as? Data,
           let storedPassword = String(data: storedData, encoding: .utf8) {
            return password == storedPassword
        }
        return false
    }
    
    func deletePassword(forFolderId folderId: UUID) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: folderId.uuidString
        ]
        SecItemDelete(query as CFDictionary)
    }
}
