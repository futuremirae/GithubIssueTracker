//
//  CreateIssueUseCase.swift
//  IssueTracker
//
//  Created by 이숲 on 10/12/24.
//

import Combine

struct CreateIssueUseCase {
    let repository: IssueRepository

    func execute(issue: RequestIssueEntity) -> AnyPublisher<Void, Error> {
        return repository.createIssue(issue: issue)
    }
}
