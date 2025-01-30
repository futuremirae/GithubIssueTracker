//
//  MilestoneListViewModel.swift
//  IssueTracker
//
//  Created by 이숲 on 10/16/24.
//

import Combine
import Foundation

final class MilestoneListViewModel: ObservableObject {
    @Published var milestoneList: [MilestoneEntity] = []
    @Published var errorMessage: String?

    private let fetchMilestoneUseCase: FetchMilestoneUseCase
    private let updateMilestoneUseCase: UpdateMilestoneUseCase
    private let deleteMilestoneUseCase: DeleteMilestoneUseCase

    private var perPage = 25
    private var cancellables = Set<AnyCancellable>()

    init(milestoneRepository: MilestoneRepository) {
        self.fetchMilestoneUseCase = FetchMilestoneUseCase(repository: milestoneRepository)
        self.updateMilestoneUseCase = UpdateMilestoneUseCase(repository: milestoneRepository)
        self.deleteMilestoneUseCase = DeleteMilestoneUseCase(repository: milestoneRepository)
    }

    func fetchMilestones(page: Int) {
        fetchMilestoneUseCase.execute(page: page, perPage: perPage)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.errorMessage = "Error fetching MilestoneList: \(error)"
                    }
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] milestoneEntities in
                DispatchQueue.main.async {
                    if !milestoneEntities.isEmpty {
                        self?.milestoneList = milestoneEntities
                    }
                }
            })
            .store(in: &self.cancellables)
    }

    func updateMilestone(milestone: MilestoneEntity) {
        let newMilestone = MilestoneEntity(
            number: milestone.number,
            title: milestone.title,
            description: milestone.description,
            state: "closed",
            dueDate: milestone.dueDate,
            openIssues: milestone.openIssues,
            closedIssues: milestone.closedIssues
        )
        guard let number = milestone.number else { return }

        updateMilestoneUseCase.execute(milestoneNumber: number, updatedMilestone: newMilestone)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.errorMessage = "Error updating Issue: \(error)"
                    }
                }
            }, receiveValue: {})
            .store(in: &cancellables)

    }

    func deleteMilestone(milestoneNumber: Int?) {
        guard let milestoneNumber = milestoneNumber else { return }

        deleteMilestoneUseCase.execute(milestoneNumber: milestoneNumber)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.errorMessage = "Error deleting Milestone: \(error)"
                    }
                }
            }, receiveValue: {})
            .store(in: &cancellables)
    }

}
