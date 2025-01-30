//
//  UserEntity.swift
//  IssueTracker
//
//  Created by 이숲 on 10/12/24.
//

struct UserEntity {
    let number: Int?
    let login: String
    let avatarUrl: String?
}

extension UserEntity {
    func toDTO() -> UserDTO {
        return UserDTO(
            number: number,
            login: login,
            avatarUrl: avatarUrl
        )
    }
}
