//
//  LabelEntity.swift
//  IssueTracker
//
//  Created by 이숲 on 10/12/24.
//

struct LabelEntity {
    let number: Int?
    var name: String
    var description: String?
    var color: String
}

extension LabelEntity {
    func toDTO() -> LabelDTO {
        return LabelDTO(
            number: number,
            name: name,
            description: description,
            color: color
        )
    }
}
