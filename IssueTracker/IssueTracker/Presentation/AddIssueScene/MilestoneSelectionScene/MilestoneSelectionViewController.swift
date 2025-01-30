//
//  MilestoneSelectionViewController.swift
//  IssueTracker
//
//  Created by 이숲 on 10/16/24.
//

import UIKit
import Combine

final class MilestoneSelectionViewController: UIViewController {

    // MARK: - Properties

    private var milestoneList: [MilestoneEntity] = []
    private var selectedMilestone: MilestoneEntity?

    private var viewModel: MilestoneSelectionViewModel
    private var cancellables = Set<AnyCancellable>()

    private var page = 0
    private var isLoading = false

    // MARK: - UI Components

    private var milestoneTableView = UITableView()

    // MARK: - Initializer

    init(viewModel: MilestoneSelectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - ViewController LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray6

        bind()

        setupViewAttributes()
        setupViewHierarchy()
        setupViewConstraints()
    }

}

// MARK: - Binding

private extension MilestoneSelectionViewController {

    func bind() {
        viewModel.$milestoneList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedMilestoneList in
                self?.milestoneList.append(contentsOf: updatedMilestoneList)
                self?.milestoneTableView.reloadData()
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

@objc extension MilestoneSelectionViewController {

    func didTappedBackButton() {
        self.dismiss(animated: true)
    }

    func didTappedCompletedButton() {
        guard let selectedMilestone else { return }
        NotificationCenter.default.post(name: .addMilestone, object: selectedMilestone)
        self.dismiss(animated: true)
    }

}

// MARK: - UI Configure

private extension MilestoneSelectionViewController {

    func setupViewAttributes() {
        setupNavigationBar()
        setupMilestoneTableView()
    }

    func setupNavigationBar() {
        self.navigationItem.title = "마일스톤"

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(didTappedBackButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "완료", style: .plain, target: self, action: #selector(didTappedCompletedButton))
    }

    func setupMilestoneTableView() {
        self.milestoneTableView.backgroundColor = .systemGray6
        self.milestoneTableView.delegate = self
        self.milestoneTableView.dataSource = self
        milestoneTableView.register(MilestoneSelectionTableViewCell.self, forCellReuseIdentifier: CellIdentifier.milestoneCellIdentifier.rawValue)
    }

    func setupViewHierarchy() {
        [
            milestoneTableView
        ].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        })
    }

    func setupViewConstraints() {
        NSLayoutConstraint.activate([
            milestoneTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16), // 상단 여백
            milestoneTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            milestoneTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16), // 좌측 여백
            milestoneTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16) // 우측 여백
        ])
    }

}

// MARK: - UITableView DataSource & Delegate

extension MilestoneSelectionViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return milestoneList.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMilestone = milestoneList[indexPath.row]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = milestoneTableView.dequeueReusableCell(withIdentifier: CellIdentifier.milestoneCellIdentifier.rawValue, for: indexPath)
                as? MilestoneSelectionTableViewCell else {
            return UITableViewCell()
        }

        cell.configureCell(name: milestoneList[indexPath.row].title)

        return cell
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
