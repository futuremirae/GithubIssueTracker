//
//  LabelService.swift
//  IssueTracker
//
//  Created by 이숲 on 10/14/24.
//

import Combine

protocol LabelService {
    func fetchLabels(page: Int, perPage: Int) -> AnyPublisher<[LabelDTO], any Error>
    func createLabel(label: LabelDTO) -> AnyPublisher<Void, Error>
    func updateLabel(labelNumber: Int, updatedLabel: LabelDTO) -> AnyPublisher<Void, Error>
    func deleteLabel(labelName: String) -> AnyPublisher<Void, Error>
}
