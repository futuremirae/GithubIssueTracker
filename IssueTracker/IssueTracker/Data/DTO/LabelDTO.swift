//
//  LabelDTO.swift
//  IssueTracker
//
//  Created by 이숲 on 10/2/24.
//

import Foundation

// MARK: - Label

struct LabelDTO: Codable {
    let number: Int?
    var name: String
    var description: String?
    var color: String

    enum CodingKeys: String, CodingKey {
        case number
        case name
        case description
        case color
    }
}

extension LabelDTO {
    func toEntity() -> LabelEntity {
        return LabelEntity(
            number: number,
            name: name,
            description: description,
            color: color
        )
    }
}
