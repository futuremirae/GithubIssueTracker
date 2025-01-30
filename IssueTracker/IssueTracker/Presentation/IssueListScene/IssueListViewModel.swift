//
//  IssueListViewModel.swift
//  IssueTracker
//
//  Created by 이숲 on 10/14/24.
//

import Combine
import Foundation

final class IssueListViewModel: ObservableObject {
    @Published var issueList: [IssueEntity] = []
    @Published var errorMessage: String?

    private let fetchIssueUseCase: FetchIssueUseCase
    private let updateIssueUseCase: UpdateIssueUseCase

    private var perPage = 25
    private var cancellables = Set<AnyCancellable>()

    init(issueRepository: IssueRepository) {
        self.fetchIssueUseCase = FetchIssueUseCase(repository: issueRepository)
        self.updateIssueUseCase = UpdateIssueUseCase(repository: issueRepository)
    }

    func fetchIssues(page: Int) {
        fetchIssueUseCase.execute(page: page, perPage: perPage)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.errorMessage = "Error fetching IssueList: \(error)"
                    }
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] issueEntities in
                DispatchQueue.main.async {
                    if !issueEntities.isEmpty {
                        self?.issueList = issueEntities
                    }
                }
            })
            .store(in: &self.cancellables)
    }

    func updateIssue(issue: IssueEntity) {
        let newIssue = RequestIssueEntity(
            title: issue.title,
            labels: issue.labels?.map { $0.name },
            state: "closed",
            assignees: issue.assignees?.map { $0.login },
            milestone: issue.milestone?.number,
            body: issue.body
        )
        guard let number = issue.number else { return }

        updateIssueUseCase.execute(issueNumber: number, updatedIssue: newIssue)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.errorMessage = "Error updating Issue: \(error)"
                    }
                }
            }, receiveValue: {})
            .store(in: &cancellables)
    }
}
