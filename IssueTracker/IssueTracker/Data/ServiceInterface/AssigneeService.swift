//
//  AssigneeService.swift
//  IssueTracker
//
//  Created by 이숲 on 10/14/24.
//

import Combine

protocol AssigneeService {
    func fetchAssignees(page: Int, perPage: Int) -> AnyPublisher<[UserDTO], any Error>
}
