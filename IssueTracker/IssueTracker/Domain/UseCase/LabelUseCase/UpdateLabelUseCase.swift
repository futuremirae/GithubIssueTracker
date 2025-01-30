//
//  UpdateLabelUseCase.swift
//  IssueTracker
//
//  Created by 이숲 on 10/14/24.
//

import Combine

struct UpdateLabelUseCase {
    let repository: LabelRepository

    func execute(labelNumber: Int, updatedLabel: LabelEntity) -> AnyPublisher<Void, Error> {
        return repository.updateLabel(labelNumber: labelNumber, updatedLabel: updatedLabel)
    }
}
