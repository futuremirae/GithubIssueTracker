//
//  LabelListViewModel.swift
//  IssueTracker
//
//  Created by 김미래 on 10/16/24.
//

import Combine
import Foundation

final class LabelListViewModel: ObservableObject {
    @Published var labelList: [LabelEntity] = []
    @Published var errorMessage: String?

    private let fetchLabelUseCase: FetchLabelUseCase
    private let deleteLabelUseCase: DeleteLabelUseCase

    private var perPage = 25
    private var cancellables = Set<AnyCancellable>()

    init(labelRepository: LabelRepository) {
        self.fetchLabelUseCase = FetchLabelUseCase(repository: labelRepository)
        self.deleteLabelUseCase = DeleteLabelUseCase(repository: labelRepository)
    }

    func fetchLabel(page: Int) {
        fetchLabelUseCase.execute(page: page, perPage: perPage)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.errorMessage = "Error fetching IssueList: \(error)"
                    }
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] labelEntities in
                DispatchQueue.main.async {
                    self?.labelList = labelEntities
                }
            })
            .store(in: &self.cancellables)
    }

    func deleteLabel(labelName: String) {
        deleteLabelUseCase.execute(labelName: labelName)
            .sink(receiveCompletion: { [weak self]
                completion in switch completion {
                case .failure(let error):
                    self?.errorMessage = "Error deleting Label: \(error.localizedDescription)"
                case .finished:
                    break
                }
            }, receiveValue: {}
            )
            .store(in: &self.cancellables)
    }

}


