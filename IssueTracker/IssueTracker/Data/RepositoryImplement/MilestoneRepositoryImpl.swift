//
//  MilestoneRepositoryImpl.swift
//  IssueTracker
//
//  Created by 이숲 on 10/14/24.
//

import Combine

final class MilestoneRepositoryImpl: MilestoneRepository {

    // MARK: - Properties

    private let milestoneService: MilestoneService

    // MARK: - Initializer

    init(milestoneService: MilestoneService) {
        self.milestoneService = milestoneService
    }

    // MARK: - CRUD

    func fetchMilestones(page: Int, perPage: Int) -> AnyPublisher<[MilestoneEntity], Error> {
        return milestoneService.fetchMilestones(page: page, perPage: perPage)
            .map { milestoneDTOs in
                milestoneDTOs.map { $0.toEntity() }
            }
            .eraseToAnyPublisher()
    }

    func createMilestone(milestone: MilestoneEntity) -> AnyPublisher<Void, Error> {
        return milestoneService.createMilestone(milestone: milestone.toDTO())
    }

    func updateMilestone(milestoneNumber: Int, updatedMilestone: MilestoneEntity) -> AnyPublisher<Void, Error> {
        return milestoneService.updateMilestone(milestoneNumber: milestoneNumber, updatedMilestone: updatedMilestone.toDTO())
    }

    func deleteMilestone(milestoneNumber: Int) -> AnyPublisher<Void, Error> {
        return milestoneService.deleteMilestone(milestoneNumber: milestoneNumber)
    }

}
