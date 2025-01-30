//
//  AssigneeSelectionViewBuilder.swift
//  IssueTracker
//
//  Created by 이숲 on 10/17/24.
//

final class AssigneeSelectionViewBuilder {

    func build() -> AssigneeSelectionViewController {
        let service = AssigneeServiceImpl(token: Token().personalAccessToken)
        let repository = AssigneeRepositoryImpl(assigneeService: service)
        let viewModel = AssigneeSelectionViewModel(assigneeRepository: repository)
        return AssigneeSelectionViewController(viewModel: viewModel)
    }

}
