//
//  IssueEntity.swift
//  IssueTracker
//
//  Created by 이숲 on 10/12/24.
//

struct IssueEntity {
    let number: Int?
    var title: String
    let user: UserEntity?
    var labels: [LabelEntity]?
    var state: String?
    var milestone: MilestoneEntity?
    var assignees: [UserEntity]?
    let createdAt: String?
    var body: String?
}

extension IssueEntity {
    func toDTO() -> IssueDTO {
        return IssueDTO(
            number: number,
            title: title,
            user: user?.toDTO(),
            labels: labels?.map { $0.toDTO() },
            state: state,
            assignees: assignees?.map { $0.toDTO() },
            milestone: milestone?.toDTO(),
            createdAt: createdAt,
            body: body
        )
    }
}
