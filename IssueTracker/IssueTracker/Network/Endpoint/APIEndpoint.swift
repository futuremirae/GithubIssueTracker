//
//  APIEndpoint.swift
//  IssueTracker
//
//  Created by 이숲 on 10/12/24.
//

struct APIEndpoints {
    static let githubURL = "https://github.com"
    static let githubApiURL = "https://api.github.com"
    static let repos = "/repos/boostcampwm-2024/_issues_repository"

    static let issues = "/issues"
    static let assignees = "/assignees"
    static let specificIssue = "/issues/%d"
    static let labels = "/labels"
    static let milestones = "/milestones"

    static let login = "/login/oauth/authorize"
    static let accessToken = "/login/oauth/access_token"
}
