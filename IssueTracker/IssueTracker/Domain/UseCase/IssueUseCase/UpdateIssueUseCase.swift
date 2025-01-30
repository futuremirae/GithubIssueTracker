//
//  UpdateIssueUseCase.swift
//  IssueTracker
//
//  Created by 이숲 on 10/12/24.
//

import Combine

struct UpdateIssueUseCase {
    let repository: IssueRepository

    func execute(issueNumber: Int, updatedIssue: RequestIssueEntity) -> AnyPublisher<Void, Error> {
        return repository.updateIssue(issueNumber: issueNumber, updatedIssue: updatedIssue)
    }
}
