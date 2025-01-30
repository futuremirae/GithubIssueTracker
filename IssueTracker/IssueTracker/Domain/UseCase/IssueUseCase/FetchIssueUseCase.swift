//
//  FetchIssueUseCase.swift
//  IssueTracker
//
//  Created by 이숲 on 10/12/24.
//

import Combine

struct FetchIssueUseCase {
    let repository: IssueRepository

    func execute(page: Int, perPage: Int) -> AnyPublisher<[IssueEntity], Error> {
        return repository.fetchIssues(page: page, perPage: perPage)
    }
}
