//
//  requestIssueDTO.swift
//  IssueTracker
//
//  Created by 이숲 on 10/14/24.
//

struct RequestIssueDTO: Codable {
    var title: String?
    var labels: [String]?
    var state: String?
    var assignees: [String]?
    var milestone: Int?
    var body: String?

    enum CodingKeys: String, CodingKey {
        case title
        case labels
        case state
        case assignees
        case milestone
        case body
    }
}
