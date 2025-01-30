//
//  DeleteIssueUseCase.swift
//  IssueTracker
//
//  Created by 이숲 on 10/12/24.
//

import Combine

struct DeleteIssueUseCase {
    let repository: IssueRepository

    func execute(issueNumber: Int) -> AnyPublisher<Void, Error> {
        return repository.deleteIssue(issueNumber: issueNumber)
    }
}
