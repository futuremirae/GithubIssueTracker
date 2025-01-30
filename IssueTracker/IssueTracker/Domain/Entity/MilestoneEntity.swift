//
//  MilestoneEntity.swift
//  IssueTracker
//
//  Created by 이숲 on 10/12/24.
//

import Foundation

struct MilestoneEntity {
    let number: Int?
    var title: String
    var description: String?
    var state: String?
    var dueDate: String?
    let openIssues: Int?
    let closedIssues: Int?
}

extension MilestoneEntity {
    func toDTO() -> MilestoneDTO {
        return MilestoneDTO(
            number: number,
            title: title,
            description: description,
            state: state,
            dueOn: toIsoDateString(formattedDate: dueDate),
            openIssues: openIssues,
            closedIssues: closedIssues
        )
    }

    func toIsoDateString(formattedDate: String?) -> String? {
        guard let dateString = formattedDate else { return nil }

        // 입력 형식: "yyyy.MM.dd."
        // 우선 "."을 "-"로 변경하고 마지막 "."을 제거
        let datePart = dateString.replacingOccurrences(of: ".", with: "-").dropLast()

        // 원하는 ISO 8601 형식으로 변환: "yyyy-MM-ddT00:00:00Z"
        let isoDateString = datePart + "T00:00:00Z"

        return String(isoDateString)
    }
}
