//
//  FetchMilestoneUseCase.swift
//  IssueTracker
//
//  Created by 이숲 on 10/14/24.
//

import Combine

struct FetchMilestoneUseCase {
    let repository: MilestoneRepository

    func execute(page: Int, perPage: Int) -> AnyPublisher<[MilestoneEntity], Error> {
        return repository.fetchMilestones(page: page, perPage: perPage)
    }
}
