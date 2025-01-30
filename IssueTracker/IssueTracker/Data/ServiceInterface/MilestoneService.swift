//
//  MilestoneService.swift
//  IssueTracker
//
//  Created by 이숲 on 10/14/24.
//

import Combine

protocol MilestoneService {
    func fetchMilestones(page: Int, perPage: Int) -> AnyPublisher<[MilestoneDTO], any Error>
    func createMilestone(milestone: MilestoneDTO) -> AnyPublisher<Void, Error>
    func updateMilestone(milestoneNumber: Int, updatedMilestone: MilestoneDTO) -> AnyPublisher<Void, Error>
    func deleteMilestone(milestoneNumber: Int) -> AnyPublisher<Void, Error>
}
