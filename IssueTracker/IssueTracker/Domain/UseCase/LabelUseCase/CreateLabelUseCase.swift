//
//  CreateLabelUseCase.swift
//  IssueTracker
//
//  Created by 이숲 on 10/14/24.
//

import Combine

struct CreateLabelUseCase {
    let repository: LabelRepository
    
    func execute(label: LabelEntity) -> AnyPublisher<Void, Error> {
        repository.createLabel(label: label)
    }
}
