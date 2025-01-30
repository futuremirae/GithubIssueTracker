//
//  DeleteMilestoneUseCase.swift
//  IssueTracker
//
//  Created by 이숲 on 10/14/24.
//

import Combine

struct DeleteMilestoneUseCase {
    let repository: MilestoneRepository

    func execute(milestoneNumber: Int) -> AnyPublisher<Void, Error> {
        return repository.deleteMilestone(milestoneNumber: milestoneNumber)
    }
}
