//
//  IssueRepository.swift
//  IssueTracker
//
//  Created by 이숲 on 10/12/24.
//

import Combine

protocol IssueRepository {
    func fetchIssues(page: Int, perPage: Int) -> AnyPublisher<[IssueEntity], Error>
    func createIssue(issue: RequestIssueEntity) -> AnyPublisher<Void, Error>
    func updateIssue(issueNumber: Int, updatedIssue: RequestIssueEntity) -> AnyPublisher<Void, Error>
    func deleteIssue(issueNumber: Int) -> AnyPublisher<Void, Error>
}
