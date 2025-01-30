//
//  IssueListViewBuilder.swift
//  IssueTracker
//
//  Created by 이숲 on 10/17/24.
//

final class IssueListViewBuilder {

    func build() -> IssueListViewController {
        let service = IssueServiceImpl(token: Token().personalAccessToken)
        let repository = IssueRepositoryImpl(issueService: service)
        let viewModel = IssueListViewModel(issueRepository: repository)
        return IssueListViewController(viewModel: viewModel)
    }

}
