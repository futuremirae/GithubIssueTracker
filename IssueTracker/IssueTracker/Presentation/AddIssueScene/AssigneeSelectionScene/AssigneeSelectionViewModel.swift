//
//  AssigneeSelectionViewModel.swift
//  IssueTracker
//
//  Created by 이숲 on 10/16/24.
//

import Combine
import Foundation

final class AssigneeSelectionViewModel: ObservableObject {
    @Published var assigneeList: [UserEntity] = []
    @Published var errorMessage: String?

    private let fetchAssigneeUseCase: FetchAssigneeUseCase

    private var perPage = 25
    private var cancellables = Set<AnyCancellable>()

    init(assigneeRepository: AssigneeRepository) {
        self.fetchAssigneeUseCase = FetchAssigneeUseCase(repository: assigneeRepository)
    }

    func fetchAssignees(page: Int) {
        fetchAssigneeUseCase.execute(page: page, perPage: perPage)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.errorMessage = "Error fetching AssigneeList: \(error)"
                    }
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] assigneeEntities in
                DispatchQueue.main.async {
                    if !assigneeEntities.isEmpty {
                        self?.assigneeList = assigneeEntities
                    }
                }
            })
            .store(in: &self.cancellables)
    }

}
