//
//  IssueDTO.swift
//  IssueTracker
//
//  Created by 이숲 on 9/23/24.
//

import Foundation

// MARK: - Issue

struct IssueDTO: Codable {
    let number: Int?
    var title: String
    let user: UserDTO?
    var labels: [LabelDTO]?
    var state: String?
    var assignees: [UserDTO]?
    var milestone: MilestoneDTO?
    let createdAt: String?
    var body: String?

    enum CodingKeys: String, CodingKey {
        case number
        case title
        case user
        case labels
        case state
        case assignees
        case milestone
        case createdAt = "created_at"
        case body
    }
}

extension IssueDTO {
    func toEntity() -> IssueEntity {
        return IssueEntity(
            number: number,
            title: title,
            user: user?.toEntity(),
            labels: labels?.map { $0.toEntity() },
            state: state,
            milestone: milestone?.toEntity(),
            assignees: assignees?.map { $0.toEntity() },
            createdAt: createdAt,
            body: body
        )
    }
}
