//
//  CreateMilestoneUseCase.swift
//  IssueTracker
//
//  Created by 이숲 on 10/14/24.
//

import Combine

struct CreateMilestoneUseCase {
    let repository: MilestoneRepository

    func execute(milestone: MilestoneEntity) -> AnyPublisher<Void, Error> {
        repository.createMilestone(milestone: milestone)
    }
}
