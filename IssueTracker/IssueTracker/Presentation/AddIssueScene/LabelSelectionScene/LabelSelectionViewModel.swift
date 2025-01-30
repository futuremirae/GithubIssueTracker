//
//  LabelSelectionViewModel.swift
//  IssueTracker
//
//  Created by 이숲 on 10/16/24.
//

import Combine
import Foundation

final class LabelSelectionViewModel: ObservableObject {
    @Published var labelList: [LabelEntity] = []
    @Published var errorMessage: String?

    private let fetchLabelUseCase: FetchLabelUseCase

    private var perPage = 25
    private var cancellables = Set<AnyCancellable>()

    init(labelRepository: LabelRepository) {
        self.fetchLabelUseCase = FetchLabelUseCase(repository: labelRepository)
    }

    func fetchLabels(page: Int) {
        fetchLabelUseCase.execute(page: page, perPage: perPage)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.errorMessage = "Error fetching LabelList: \(error)"
                    }
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] labelEntities in
                DispatchQueue.main.async {
                    if !labelEntities.isEmpty {
                        self?.labelList = labelEntities
                    }
                }
            })
            .store(in: &self.cancellables)
    }

}
