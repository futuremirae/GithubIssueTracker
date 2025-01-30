//
//  MilestoneRepository.swift
//  IssueTracker
//
//  Created by 이숲 on 10/14/24.
//

import Combine

protocol MilestoneRepository {
    func fetchMilestones(page: Int, perPage: Int) -> AnyPublisher<[MilestoneEntity], Error>
    func createMilestone(milestone: MilestoneEntity) -> AnyPublisher<Void, Error>
    func updateMilestone(milestoneNumber: Int, updatedMilestone: MilestoneEntity) -> AnyPublisher<Void, Error>
    func deleteMilestone(milestoneNumber: Int) -> AnyPublisher<Void, Error>
}
