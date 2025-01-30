//
//  MilestoneSelectionViewBuilder.swift
//  IssueTracker
//
//  Created by 이숲 on 10/17/24.
//

final class MilestoneSelectionViewBuilder {

    func build() -> MilestoneSelectionViewController {
        let service = MilestoneServiceImpl(token: Token().personalAccessToken)
        let repository = MilestoneRepositoryImpl(milestoneService: service)
        let viewModel = MilestoneSelectionViewModel(milestoneRepository: repository)
        return MilestoneSelectionViewController(viewModel: viewModel)
    }
}
