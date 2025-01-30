//
//  FetchLabelUseCase.swift
//  IssueTracker
//
//  Created by 이숲 on 10/14/24.
//

import Combine

struct FetchLabelUseCase {
    let repository: LabelRepository

    func execute(page: Int, perPage: Int) -> AnyPublisher<[LabelEntity], Error> {
        return repository.fetchLabels(page: page, perPage: perPage)
    }
}
