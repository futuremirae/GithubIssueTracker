//
//  AssigneeRepositoryImpl.swift
//  IssueTracker
//
//  Created by 이숲 on 10/14/24.
//

import Combine

final class AssigneeRepositoryImpl: AssigneeRepository {

    // MARK: - Properties

    private let assigneeService: AssigneeService

    // MARK: - Initializer

    init(assigneeService: AssigneeService) {
        self.assigneeService = assigneeService
    }

    func fetchAssignees(page: Int, perPage: Int) -> AnyPublisher<[UserEntity], Error> {
        return assigneeService.fetchAssignees(page: page, perPage: perPage)
            .map { assigneeDTOs in
                assigneeDTOs.map { $0.toEntity() }
            }
            .eraseToAnyPublisher()
    }
}
