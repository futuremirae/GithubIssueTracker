//
//  LabelListViewBuilder.swift
//  IssueTracker
//
//  Created by 이숲 on 10/17/24.
//

final class LabelListViewBuilder {

    func build() -> LabelListViewController {
        let service = LabelServiceImpl(token: Token().personalAccessToken)
        let repository = LabelRepositoryImpl(labelService: service)
        let viewModel = LabelListViewModel(labelRepository: repository)
        return LabelListViewController(viewModel: viewModel)
    }

}
