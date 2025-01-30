//
//  FetchAssigneeUseCase.swift
//  IssueTracker
//
//  Created by 이숲 on 10/14/24.
//

import Combine

struct FetchAssigneeUseCase {
    let repository: AssigneeRepository

    func execute(page: Int, perPage: Int) -> AnyPublisher<[UserEntity], Error> {
        return repository.fetchAssignees(page: page, perPage: perPage)
    }
}
