//
//  RequestIssueEntity.swift
//  IssueTracker
//
//  Created by 이숲 on 10/14/24.
//

struct RequestIssueEntity {
    var title: String?
    var labels: [String]?
    var state: String?
    var assignees: [String]?
    var milestone: Int?
    var body: String?
}

extension RequestIssueEntity {
    func toDTO() -> RequestIssueDTO {
        return RequestIssueDTO(
            title: title,
            labels: labels,
            state: state,
            assignees: assignees,
            milestone: milestone,
            body: body
        )
    }
}
