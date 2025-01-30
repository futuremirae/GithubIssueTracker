//
//  MilestoneSelectionViewModel.swift
//  IssueTracker
//
//  Created by 이숲 on 10/16/24.
//

import Combine
import Foundation

final class MilestoneSelectionViewModel: ObservableObject {
    @Published var milestoneList: [MilestoneEntity] = []
    @Published var errorMessage: String?

    private let fetchMilestoneUseCase: FetchMilestoneUseCase

    private var perPage = 25
    private var cancellables = Set<AnyCancellable>()

    init(milestoneRepository: MilestoneRepository) {
        self.fetchMilestoneUseCase = FetchMilestoneUseCase(repository: milestoneRepository)
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

}
