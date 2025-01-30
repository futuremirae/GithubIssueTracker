//
//  KeychainError.swift
//  IssueTracker
//
//  Created by 이숲 on 10/15/24.
//

enum KeychainError: Error {
    case itemNotFound
    case keychainError

    var errorDescription: String? {
        switch self {
        case .itemNotFound:
            return "Item not found"
        case .keychainError:
            return "Keychain error"
        }
    }
}
