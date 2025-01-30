//
//  IssueRepositoryImpl.swift
//  IssueTracker
//
//  Created by 이숲 on 10/12/24.
//

import Combine

final class IssueRepositoryImpl: IssueRepository {
    private let issueService: IssueService

    init(issueService: IssueService) {
        self.issueService = issueService
    }

    func fetchIssues(page: Int, perPage: Int) -> AnyPublisher<[IssueEntity], Error> {
        return issueService.fetchIssues(page: page, perPage: perPage)
            .map { issueDTOs in
                issueDTOs.map { $0.toEntity() } // DTO를 Entity로 변환
            }
            .eraseToAnyPublisher()
    }

    func createIssue(issue: RequestIssueEntity) -> AnyPublisher<Void, Error> {
        return issueService.createIssue(issue: issue.toDTO())
    }

    func updateIssue(issueNumber: Int, updatedIssue: RequestIssueEntity) -> AnyPublisher<Void, Error> {
        return issueService.updateIssue(issueNumber: issueNumber, updatedIssue: updatedIssue.toDTO())
    }

    func deleteIssue(issueNumber: Int) -> AnyPublisher<Void, Error> {
        return issueService.deleteIssue(issueNumber: issueNumber)
    }
}
