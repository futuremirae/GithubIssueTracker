//
//  MilestoneListViewController.swift
//  IssueTracker
//
//  Created by 이숲 on 10/16/24.
//

import UIKit
import Combine
import SwiftUI

final class MilestoneListViewController: UIViewController {

    // MARK: - Properties

    private var milestoneList: [MilestoneEntity] = []

    private var viewModel: MilestoneListViewModel
    private var cancellables = Set<AnyCancellable>()

    private var page = 0
    private var isLoading = false

    // MARK: - UI Components

    private var milestoneTableview = UITableView()
    private var searchController: UISearchController?

    // MARK: - Initializer

    init(viewModel: MilestoneListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - ViewController LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        milestoneTableview.delegate = self
        milestoneTableview.dataSource = self

        bind()

        setupViewAttributes()
        setupViewHierarchy()
        setupViewConstraints()

        viewModel.fetchMilestones(page: page)
    }

}

// MARK: - Binding

private extension MilestoneListViewController {

    func bind() {
        viewModel.$milestoneList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedMilestoneList in
                self?.milestoneList.append(contentsOf: updatedMilestoneList)
                self?.milestoneTableview.reloadData()
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

@objc extension MilestoneListViewController {

//    func addMilestone() {
//        let addMilestoneView = AddMilestoneView(dismiss: { self.dismiss(animated: true) })
//        let addMilestoneViewController = UIHostingController(rootView: addMilestoneView)
//        let navigationController = UINavigationController(rootViewController: addMilestoneViewController)
//        self.present(navigationController, animated: true)
//    }

    func closeMilestone(index: Int) {
        self.viewModel.updateMilestone(milestone: self.milestoneList[index])
        self.milestoneList.remove(at: index)
        self.milestoneTableview.reloadData()
    }

    func deleteMilestone(index: Int) {
        self.viewModel.deleteMilestone(milestoneNumber: self.milestoneList[index].number)
        self.milestoneList.remove(at: index)
        self.milestoneTableview.reloadData()
    }

    func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.page = 1
            self.milestoneList.removeAll()
            self.viewModel.fetchMilestones(page: self.page)
            self.milestoneTableview.reloadData()
            self.milestoneTableview.refreshControl?.endRefreshing()
        }
    }

}

// MARK: - UI Configure

private extension MilestoneListViewController {

    func setupViewAttributes() {
        setupNavigationBar()
        setupTableView()
    }

    func setupNavigationBar() {
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addMilestone))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: nil)
        self.navigationItem.title = "마일스톤"
    }

    func setupTableView() {
        milestoneTableview.register(MilestoneTableViewCell.self, forCellReuseIdentifier: CellIdentifier.milestoneCellIdentifier.rawValue)

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)

        milestoneTableview.refreshControl = refreshControl
    }

    func setupViewHierarchy() {
        [
            milestoneTableview
        ].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        })
    }

    func setupViewConstraints() {
        NSLayoutConstraint.activate([
            milestoneTableview.topAnchor.constraint(equalTo: self.view.topAnchor),
            milestoneTableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            milestoneTableview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            milestoneTableview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }

}

// MARK: - UITableView DataSource & Delegate

extension MilestoneListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        milestoneList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "milestoneCell", for: indexPath)
        guard let cell = cell as? MilestoneTableViewCell else { return cell }
        cell.configureCell(milestone: milestoneList[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "") { (_, _, success: @escaping (Bool) -> Void) in
            let alert = UIAlertController(title: "정말로 이 이슈를 보관하시겠습니까?", message: "", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "네", style: .default) { _ in
                self.closeMilestone(index: indexPath.row)
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

        edit.backgroundColor = .systemPurple
        edit.image = UIImage(systemName: "tray.fill")

        let delete = UIContextualAction(style: .normal, title: "") { (_, _, success: @escaping (Bool) -> Void) in
            let alert = UIAlertController(title: "정말로 이 이슈를 삭제하시겠습니까?", message: "", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "네", style: .default) { _ in
                self.deleteMilestone(index: indexPath.row)
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

        return UISwipeActionsConfiguration(actions: [delete, edit])
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight * 1.5 {
            if !isLoading {
                isLoading = true
                viewModel.fetchMilestones(page: page)
            }
        }
    }

}
