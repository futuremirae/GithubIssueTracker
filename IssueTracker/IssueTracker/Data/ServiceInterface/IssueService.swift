//
//  IssueService.swift
//  IssueTracker
//
//  Created by 이숲 on 10/12/24.
//

import Combine

protocol IssueService {
    func fetchIssues(page: Int, perPage: Int) -> AnyPublisher<[IssueDTO], Error>
    func createIssue(issue: RequestIssueDTO) -> AnyPublisher<Void, Error>
    func updateIssue(issueNumber: Int, updatedIssue: RequestIssueDTO) -> AnyPublisher<Void, Error>
    func deleteIssue(issueNumber: Int) -> AnyPublisher<Void, Error>
}
