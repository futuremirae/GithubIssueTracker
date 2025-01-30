//
//  LabelRepositoryImpl.swift
//  IssueTracker
//
//  Created by 이숲 on 10/14/24.
//

import Combine

final class LabelRepositoryImpl: LabelRepository {

    // MARK: - Properties

    private let labelService: LabelService

    // MARK: - Initializer

    init(labelService: LabelService) {
        self.labelService = labelService
    }

    // MARK: - CRUD

    func fetchLabels(page: Int, perPage: Int) -> AnyPublisher<[LabelEntity], Error> {
        return labelService.fetchLabels(page: page, perPage: perPage)
            .map { labelDTOs in
                labelDTOs.map { $0.toEntity() }
            }
            .eraseToAnyPublisher()
    }

    func createLabel(label: LabelEntity) -> AnyPublisher<Void, Error> {
        return labelService.createLabel(label: label.toDTO())
    }

    func updateLabel(labelNumber: Int, updatedLabel: LabelEntity) -> AnyPublisher<Void, Error> {
        return labelService.updateLabel(labelNumber: labelNumber, updatedLabel: updatedLabel.toDTO())
    }

    func deleteLabel(labelName: String) -> AnyPublisher<Void, Error> {
        return labelService.deleteLabel(labelName: labelName)
    }

}
