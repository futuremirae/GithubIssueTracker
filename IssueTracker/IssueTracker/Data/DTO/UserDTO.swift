//
//  UserDTO.swift
//  IssueTracker
//
//  Created by 이숲 on 10/2/24.
//

import Foundation

// MARK: - User

struct UserDTO: Codable {
    let number: Int?
    let login: String
    let avatarUrl: String?

    enum CodingKeys: String, CodingKey {
        case number
        case login
        case avatarUrl = "avatar_url"
    }
}

extension UserDTO {
    func toEntity() -> UserEntity {
        return UserEntity(
            number: number,
            login: login,
            avatarUrl: avatarUrl
        )
    }
}
