//
//  UpdateMilestoneUseCase.swift
//  IssueTracker
//
//  Created by 이숲 on 10/14/24.
//

import Combine

struct UpdateMilestoneUseCase {
    let repository: MilestoneRepository

    func execute(milestoneNumber: Int, updatedMilestone: MilestoneEntity) -> AnyPublisher<Void, Error> {
        return repository.updateMilestone(milestoneNumber: milestoneNumber, updatedMilestone: updatedMilestone)
    }
}
