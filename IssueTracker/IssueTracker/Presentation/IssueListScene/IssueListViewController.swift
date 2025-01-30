//
//  ViewController.swift
//  IssueTracker
//
//  Created by 김미래 on 9/23/24.
//

import UIKit
import Combine
import SwiftUI

final class IssueListViewController: UIViewController {

    // MARK: - Properties

    private var issueList: [IssueEntity] = []
    private var selectedSearchToken: [Any] = []

    private var viewModel: IssueListViewModel
    private var cancellables = Set<AnyCancellable>()

    private var page = 0
    private var isLoading = false

    // MARK: - UI Components

    private var issueTableview = UITableView()
    private var searchController: UISearchController?

    // MARK: - Initializer

    init(viewModel: IssueListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - ViewController LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        issueTableview.delegate = self
        issueTableview.dataSource = self

        bind()

        setupViewAttributes()
        setupViewHierarchy()
        setupViewConstraints()

        viewModel.fetchIssues(page: page)
    }

}

// MARK: - Binding

private extension IssueListViewController {

    func bind() {
        viewModel.$issueList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedIssueList in
                self?.issueList.append(contentsOf: updatedIssueList)
                self?.issueTableview.reloadData()
                self?.isLoading = false
                self?.page += 1
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .compactMap { $0 } // nil 값은 필터링
            .sink { [weak self] errorMessage in
                print(errorMessage)
            }
            .store(in: &cancellables)
    }

}

// MARK: - Action Methods

@objc extension IssueListViewController {

    func addIssue() {
        let addIssueView = AddIssueView(dismiss: { self.dismiss(animated: true) })
        let addIssueViewController = UIHostingController(rootView: addIssueView)
        let navigationController = UINavigationController(rootViewController: addIssueViewController)
        self.present(navigationController, animated: true)
    }

    func closeIssue(index: Int) {
        self.viewModel.updateIssue(issue: self.issueList[index])
        self.issueList.remove(at: index)
        self.issueTableview.reloadData()
    }

    func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.page = 1
            self.issueList.removeAll()
            self.viewModel.fetchIssues(page: self.page)
            self.issueTableview.reloadData()
            self.issueTableview.refreshControl?.endRefreshing()
        }
    }

}

// MARK: - UI Configure

private extension IssueListViewController {

    func setupViewAttributes() {
        setupNavigationBar()
        setupSearchBar()
        setupTableView()
    }

    func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "선택", style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addIssue))
        self.navigationItem.title = "이슈"
    }

    func setupSearchBar() {
        let searchVC = SearchViewController(issues: self.issueList)
        searchVC.delegate = self
        searchController?.delegate = self
        searchController = UISearchController(searchResultsController: searchVC)
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.placeholder = "검색"
        searchController?.searchBar.setValue("취소", forKey: "cancelButtonText")

        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = true
    }

    func setupTableView() {
        issueTableview.register(IssueTableViewCell.self, forCellReuseIdentifier: CellIdentifier.issueCellIdentifier.rawValue)

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)

        issueTableview.refreshControl = refreshControl
    }

    func setupViewHierarchy() {
        [
            issueTableview
        ].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        })
    }

    func setupViewConstraints() {
        NSLayoutConstraint.activate([
            issueTableview.topAnchor.constraint(equalTo: self.view.topAnchor),
            issueTableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            issueTableview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            issueTableview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }

}

// MARK: - UITableView DataSource & Delegate

extension IssueListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        issueList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "issueCell", for: indexPath)
        guard let cell = cell as? IssueTableViewCell else { return cell }
        cell.configureCell(issue: issueList[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let close = UIContextualAction(style: .normal, title: "") { (_, _, success: @escaping (Bool) -> Void) in
            let alert = UIAlertController(title: "정말로 이 이슈를 닫으시겠습니까?", message: "", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "네", style: .default) { _ in
                self.closeIssue(index: indexPath.row)
                success(true)
            }
            let cancel = UIAlertAction(title: "아니오", style: .cancel) { _ in
                success(false)
            }

            alert.addAction(cancel)
            alert.addAction(confirm)

            self.present(alert, animated: true, completion: nil)
            success(false)
        }

        close.backgroundColor = .systemPurple
        close.image = UIImage(systemName: "tray.fill")

        let delete = UIContextualAction(style: .normal, title: "") { (_, _, success: @escaping (Bool) -> Void) in
            let alert = UIAlertController(title: "정말로 이 이슈를 삭제하시겠습니까?", message: "", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "네", style: .default) { _ in
                self.closeIssue(index: indexPath.row)
                success(true)
            }
            let cancel = UIAlertAction(title: "아니오", style: .cancel) { _ in
                success(false)
            }

            alert.addAction(cancel)
            alert.addAction(confirm)

            self.present(alert, animated: true, completion: nil)

            success(false)
        }

        delete.backgroundColor = .systemRed
        delete.image = UIImage(systemName: "trash.fill")

        return UISwipeActionsConfiguration(actions: [close, delete])
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight * 1.5 {
            if !isLoading {
                isLoading = true
                viewModel.fetchIssues(page: page)
            }
        }
    }

}

// MARK: - SearchController Updating & Delegate

extension IssueListViewController: UISearchResultsUpdating, UISearchControllerDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        searchController.showsSearchResultsController = true
    }
}

// MARK: - SearchFilterTableView Delegate

extension IssueListViewController: SearchFilterTableViewDelegate {

    func searchFor(token: UISearchToken) {
        if let token = token.representedObject as? FilterToken<IssueEntity> {
            let condition = token.conditon
            selectedSearchToken.append(condition)
            print("현재 조건 클로저: ", selectedSearchToken)

            let filteredIssues = issueList.filter { issue in
                selectedSearchToken.allSatisfy { condtion in
                    guard let condtion = condtion as? (IssueEntity) -> Bool else { return false }
                return condtion(issue)}
            }

            if let searchVC = searchController?.searchResultsController as? SearchViewController {
                searchVC.filteredIssues(issues: filteredIssues)
            }
        }
    }

    func didSelect(_ searchFilterTableView: UITableView, token: FilterToken<IssueEntity>) {
        let cellToken = UISearchToken(icon: UIImage(systemName: token.icon), text: token.description)
        cellToken.representedObject = token

        if  let searchTextField = searchController?.searchBar.searchTextField {
            if searchTextField.tokens.count == 0 {
                selectedSearchToken = []
            }
            searchTextField.insertToken(cellToken, at: searchTextField.tokens.count)
            searchFor(token: cellToken)
        }
    }

}
