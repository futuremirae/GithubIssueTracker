//
//  DeleteLabelUseCase.swift
//  IssueTracker
//
//  Created by 이숲 on 10/14/24.
//

import Combine

struct DeleteLabelUseCase {
    let repository: LabelRepository

    func execute(labelName: String) -> AnyPublisher<Void, Error> {
        return repository.deleteLabel(labelName: labelName)
    }
}
