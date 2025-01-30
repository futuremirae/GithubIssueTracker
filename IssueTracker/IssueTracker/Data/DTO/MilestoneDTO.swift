//
//  MilestoneDTO.swift
//  IssueTracker
//
//  Created by 이숲 on 10/2/24.
//

import Foundation

// MARK: - Milestone

struct MilestoneDTO: Codable {
    let number: Int?
    var title: String
    var description: String?
    var state: String?
    var dueOn: String?
    let openIssues: Int?
    let closedIssues: Int?

    enum CodingKeys: String, CodingKey {
        case number
        case title
        case description
        case state
        case dueOn = "due_on"  // JSON 필드 이름과 매핑
        case openIssues = "open_issues"
        case closedIssues = "closed_issues"
    }
}

extension MilestoneDTO {
    func toEntity() -> MilestoneEntity {
        return MilestoneEntity(
            number: number,
            title: title,
            description: description,
            state: state,
            dueDate: toFormattedDateString(dueOn),
            openIssues: openIssues,
            closedIssues: closedIssues
        )
    }

    func toFormattedDateString(_ isoDateString: String?) -> String? {
        guard let dateString = isoDateString else { return nil }

        // ISO 8601 형식: "2024-09-27T07:00:00Z" -> "2024.09.27."
        let components = dateString.split(separator: "T")  // "2024-09-27T07:00:00Z"를 "2024-09-27"와 "07:00:00Z"로 분리
        guard let datePart = components.first else { return nil }

        // 날짜 부분 "2024-09-27"을 "."으로 변경
        let formattedDate = datePart.replacingOccurrences(of: "-", with: ".") + "."

        return formattedDate
    }
}
