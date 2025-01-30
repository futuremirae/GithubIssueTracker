//
//  MilestoneListViewBuilder.swift
//  IssueTracker
//
//  Created by 이숲 on 10/17/24.
//

final class MilestoneListViewBuilder {

    func build() -> MilestoneListViewController {
        let service = MilestoneServiceImpl(token: Token().personalAccessToken)
        let repository = MilestoneRepositoryImpl(milestoneService: service)
        let viewModel = MilestoneListViewModel(milestoneRepository: repository)
        return MilestoneListViewController(viewModel: viewModel)
    }
}
