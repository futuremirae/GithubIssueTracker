//
//  LabelRepository.swift
//  IssueTracker
//
//  Created by 이숲 on 10/14/24.
//

import Combine

protocol LabelRepository {
    func fetchLabels(page: Int, perPage: Int) -> AnyPublisher<[LabelEntity], Error>
    func createLabel(label: LabelEntity) -> AnyPublisher<Void, Error>
    func updateLabel(labelNumber: Int, updatedLabel: LabelEntity) -> AnyPublisher<Void, Error>
    func deleteLabel(labelName: String) -> AnyPublisher<Void, Error>
}
