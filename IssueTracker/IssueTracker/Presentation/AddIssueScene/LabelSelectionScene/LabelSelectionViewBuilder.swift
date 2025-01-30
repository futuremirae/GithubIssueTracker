//
//  LabelSelectionViewBuilder.swift
//  IssueTracker
//
//  Created by 이숲 on 10/17/24.
//

final class LabelSelectionViewBuilder {

    func build() -> LabelSelectionViewController {
        let service = LabelServiceImpl(token: Token().personalAccessToken)
        let repository = LabelRepositoryImpl(labelService: service)
        let viewModel = LabelSelectionViewModel(labelRepository: repository)
        return LabelSelectionViewController(viewModel: viewModel)
    }

}
