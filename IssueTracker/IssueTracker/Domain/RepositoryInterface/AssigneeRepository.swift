//
//  AssigneeRepository.swift
//  IssueTracker
//
//  Created by 이숲 on 10/14/24.
//

import Combine

protocol AssigneeRepository {
    func fetchAssignees(page: Int, perPage: Int) -> AnyPublisher<[UserEntity], Error>
}
