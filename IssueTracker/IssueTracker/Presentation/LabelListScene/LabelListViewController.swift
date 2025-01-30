//
//  LabelListViewController.swift
//  IssueTracker
//
//  Created by 김미래 on 10/16/24.
//

import UIKit
import Combine
import SwiftUI

final class LabelListViewController: UIViewController {

    // MARK: - Properties

    private var labelList: [LabelEntity] = []

    private var viewModel: LabelListViewModel
    private var cancellables = Set<AnyCancellable>()

    private var page = 0
    private var isLoading = false

    // MARK: - UI Components

    private var labelTableView = UITableView()

    // MARK: - Initializer

    init(viewModel: LabelListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - ViewController LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        labelTableView.delegate = self
        labelTableView.dataSource = self

        bind()

        setupViewAttributes()
        setupViewHierarchy()
        setupViewConstraints()

        viewModel.fetchLabel(page: page)
    }

}

// MARK: - Binding

private extension LabelListViewController {

    func bind() {
        viewModel.$labelList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedLabelList in
                self?.labelList.append(contentsOf: updatedLabelList)
                self?.labelTableView.reloadData()
                self?.isLoading = false
                self?.page += 1
                self?.page += 1
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .compactMap { $0 }
            .sink { [weak self] errorMessage in
                print(errorMessage)
            }
            .store(in: &cancellables)
    }

}

// MARK: - Action Methods

@objc extension LabelListViewController {
    //MARK: 수정 필요 - 다른 뷰로 넘기기
    func addLabel() {
        let addIssueView = AddIssueView(dismiss: { self.dismiss(animated: true) })
        let addIssueViewController = UIHostingController(rootView: addIssueView)
        let navigationController = UINavigationController(rootViewController: addIssueViewController)
        self.present(navigationController, animated: true)
    }
    //TODO: 레이블 수정 페이지 구현 필요
    func editLabel() {}

    func deleteLabel(index: Int) {
        let name = self.labelList[index].name
        self.viewModel.deleteLabel(labelName: name)
        self.labelList.remove(at: index)
        self.labelTableView.reloadData()

    }

    func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.page = 1
            self.labelList.removeAll()
            self.viewModel.fetchLabel(page: self.page)
            self.labelTableView.reloadData()
            self.labelTableView.refreshControl?.endRefreshing()
        }
    }

}

// MARK: - UI Configure

private extension LabelListViewController {

    func setupViewAttributes() {
        setupNavigationBar()
        setupTableView()
    }

    func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addLabel))
        self.navigationItem.title = "레이블"
    }
    //TODO: CellIdentifier에 추가 필요 !
    func setupTableView() {
        labelTableView.register(LabelListTableViewCell.self, forCellReuseIdentifier: CellIdentifier.labelCellIdentifier.rawValue)

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)

        labelTableView.refreshControl = refreshControl
    }

    func setupViewHierarchy() {
        [
            labelTableView
        ].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        })
    }

    func setupViewConstraints() {
        NSLayoutConstraint.activate([
            labelTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            labelTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            labelTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            labelTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }

}

// MARK: - UITableView DataSource & Delegate

extension LabelListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        labelList.count
    }
    //TODO: 셀 부분 configureCell 매개변수 조정 필요
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.labelCellIdentifier.rawValue, for: indexPath)

        guard let cell = cell as? LabelListTableViewCell else { return cell }
        cell.configureCell(name: labelList[indexPath.row].name, color: labelList[indexPath.row].color, description: labelList[indexPath.row].description ?? "")
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight * 1.5 {
            if !isLoading {
                isLoading = true
                viewModel.fetchLabel(page: page)
            }
        }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "") { (_, _, success: @escaping (Bool) -> Void) in
            let alert = UIAlertController(title: "레이블을 수정하시겠습니까?", message: "", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "네", style: .default) { _ in
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

        edit.backgroundColor = .systemBlue
        edit.image = UIImage(systemName: "eraser")

        let delete = UIContextualAction(style: .normal, title: "") { (_, _, success: @escaping (Bool) -> Void) in
            let alert = UIAlertController(title: "정말로 이 이슈를 삭제하시겠습니까?", message: "", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "네", style: .default) { _ in
                success(true)
                self.deleteLabel(index: indexPath.row)
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

        return UISwipeActionsConfiguration(actions: [edit, delete])
    }

}


