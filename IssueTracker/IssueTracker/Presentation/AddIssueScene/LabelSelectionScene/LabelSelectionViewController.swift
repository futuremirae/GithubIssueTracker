//
//  LabelSelectionViewController.swift
//  IssueTracker
//
//  Created by 이숲 on 10/16/24.
//

import UIKit
import Combine

final class LabelSelectionViewController: UIViewController {

    // MARK: - Properties

    private var labelList: [LabelEntity] = []
    private var selectedLabel: LabelEntity?

    private var viewModel: LabelSelectionViewModel
    private var cancellables = Set<AnyCancellable>()

    private var page = 0
    private var isLoading = false

    // MARK: - UI Components

    private var labelTableView = UITableView()

    // MARK: - Initializer

    init(viewModel: LabelSelectionViewModel) {
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

private extension LabelSelectionViewController {

    func bind() {
        viewModel.$labelList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedLabelList in
                self?.labelList.append(contentsOf: updatedLabelList)
                self?.labelTableView.reloadData()
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

@objc extension LabelSelectionViewController {

    func didTappedBackButton() {
        self.dismiss(animated: true)
    }

    func didTappedCompletedButton() {
        guard let selectedLabel else { return }
        NotificationCenter.default.post(name: .addLabel, object: selectedLabel)
        self.dismiss(animated: true)
    }

}

// MARK: - UI Configure

private extension LabelSelectionViewController {

    func setupViewAttributes() {
        setupNavigationBar()
        setupLabelTableView()
    }

    func setupNavigationBar() {
        self.navigationItem.title = "레이블"

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(didTappedBackButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "완료", style: .plain, target: self, action: #selector(didTappedCompletedButton))
    }

    func setupLabelTableView() {
        self.labelTableView.backgroundColor = .systemGray6
        self.labelTableView.delegate = self
        self.labelTableView.dataSource = self
        labelTableView.register(LabelSelectionTableViewCell.self, forCellReuseIdentifier: CellIdentifier.labelCellIdentifier.rawValue)
    }

    func setupViewHierarchy() {
        [
            labelTableView
        ].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        })
    }

    func setupViewConstraints() {
        NSLayoutConstraint.activate([
            labelTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16), // 상단 여백
            labelTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            labelTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16), // 좌측 여백
            labelTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16) // 우측 여백
        ])
    }

}

// MARK: - UITableView DataSource & Delegate

extension LabelSelectionViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelList.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLabel = labelList[indexPath.row]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = labelTableView.dequeueReusableCell(withIdentifier: CellIdentifier.labelCellIdentifier.rawValue, for: indexPath)
                as? LabelSelectionTableViewCell else {
            return UITableViewCell()
        }

        cell.configureCell(name: labelList[indexPath.row].name, color: labelList[indexPath.row].color)

        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight * 1.5 {
            if !isLoading {
                isLoading = true
                viewModel.fetchLabels(page: page)
            }
        }
    }

}
