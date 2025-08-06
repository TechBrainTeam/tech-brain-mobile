//
//  TokenManager.swift
//  FobiniYen
//
//  Created by Serhat Şimşek on 2.08.2025.
//

import Foundation
import Security

// MARK: - Token Manager
final class TokenManager {
    
    static let shared = TokenManager()
    
    private let service = Bundle.main.bundleIdentifier ?? "com.serhatsimsek.FobiniYen"
    private let accessTokenKey = "access_token"
    private let refreshTokenKey = "refresh_token"
    private let userDataKey = "user_data"
    
    private init() {}
    
    // MARK: - Public Methods
    func saveTokens(accessToken: String, refreshToken: String? = nil) {
        saveToken(accessToken, forKey: accessTokenKey)
        if let refreshToken = refreshToken {
            saveToken(refreshToken, forKey: refreshTokenKey)
        }
    }
    
    func getAccessToken() -> String? {
        return getToken(forKey: accessTokenKey)
    }
    
    func getRefreshToken() -> String? {
        return getToken(forKey: refreshTokenKey)
    }
    
    func clearTokens() {
        deleteToken(forKey: accessTokenKey)
        deleteToken(forKey: refreshTokenKey)
        deleteToken(forKey: userDataKey)
    }
    
    func isLoggedIn() -> Bool {
        return getAccessToken() != nil
    }
    
    func saveUser(_ user: User) {
        do {
            let userData = try JSONEncoder().encode(user)
            saveToken(String(data: userData, encoding: .utf8)!, forKey: userDataKey)
        } catch {
            print("❌ User data kaydedilemedi: \(error)")
        }
    }
    
    func getCurrentUser() -> User? {
        guard let userDataString = getToken(forKey: userDataKey),
              let userData = userDataString.data(using: .utf8) else {
            return nil
        }
        
        do {
            let user = try JSONDecoder().decode(User.self, from: userData)
            return user
        } catch {
            print("❌ User data çözümlenemedi: \(error)")
            return nil
        }
    }
    
    // MARK: - Private Methods (Keychain Operations)
    private func saveToken(_ token: String, forKey key: String) {
        let data = token.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        // Önce varsa sil
        SecItemDelete(query as CFDictionary)
        
        // Yeni token'ı kaydet
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func getToken(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data {
                return String(data: data, encoding: .utf8)
            }
        }
        
        return nil
    }
    
    private func deleteToken(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
