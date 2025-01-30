//
//  Keychain.swift
//  IssueTracker
//
//  Created by 이숲 on 10/10/24.
//

import Foundation
import Security

final class Keychain {

    // MARK: - Properties

    private let service: String = "com.mirae.IssueTracker"

}

extension Keychain {

    func set(account: String, value: String) throws {
        let data: Data = value.data(using: .utf8)!

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary) // 기존 항목 삭제
        let status = SecItemAdd(query as CFDictionary, nil) // 새로운 항목 추가

        if status != errSecSuccess {
            throw KeychainError.keychainError
        }
    }

    func get(account: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject? = nil
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess {
            guard let data = dataTypeRef as? Data  else { return nil }
            let stringValue = String(data: data, encoding: .utf8)
            return stringValue
        } else if status == errSecItemNotFound {
            throw KeychainError.itemNotFound
        } else {
            throw KeychainError.keychainError
        }
    }

    func remove(account: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        let status = SecItemDelete(query as CFDictionary)

        if status != errSecSuccess {
            throw KeychainError.keychainError
        }
    }

}
