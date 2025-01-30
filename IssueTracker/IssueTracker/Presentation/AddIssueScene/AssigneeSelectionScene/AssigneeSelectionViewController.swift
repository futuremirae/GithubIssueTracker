//
//  AssigneeSelectionViewController.swift
//  IssueTracker
//
//  Created by 김미래 on 9/25/24.
//

import UIKit
import Combine

final class AssigneeSelectionViewController: UIViewController {

    // MARK: - Properties

    private var assigneeList: [UserEntity] = []
    private var selectedUser: UserEntity?

    private var viewModel: AssigneeSelectionViewModel
    private var cancellables = Set<AnyCancellable>()

    private var page = 0
    private var isLoading = false

    // MARK: - UI Components

    private var assigneeTableView = UITableView()

    // MARK: - Initializer

    init(viewModel: AssigneeSelectionViewModel) {
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

private extension AssigneeSelectionViewController {

    func bind() {
        viewModel.$assigneeList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedAssigneeList in
                self?.assigneeList.append(contentsOf: updatedAssigneeList)
                self?.assigneeTableView.reloadData()
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

@objc extension AssigneeSelectionViewController {

    func didTappedBackButton() {
        self.dismiss(animated: true)
    }

    func didTappedCompletedButton() {
        guard let selectedUser else { return }
        NotificationCenter.default.post(name: .addAssignee, object: selectedUser)
        self.dismiss(animated: true)
    }

}

// MARK: - UI Configure

private extension AssigneeSelectionViewController {

    func setupViewAttributes() {
        setupNavigationBar()
        setupAssigneeTableView()
    }

    func setupNavigationBar() {
        self.navigationItem.title = "담당자"

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(didTappedBackButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "완료", style: .plain, target: self, action: #selector(didTappedCompletedButton))
    }

    func setupAssigneeTableView() {
        self.assigneeTableView.backgroundColor = .systemGray6
        self.assigneeTableView.delegate = self
        self.assigneeTableView.dataSource = self
        assigneeTableView.register(AssigneeTableViewCell.self, forCellReuseIdentifier: CellIdentifier.assigneeCellIdentifier.rawValue)

    }

    func setupViewHierarchy() {
        [
            assigneeTableView
        ].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        })
    }

    func setupViewConstraints() {
        NSLayoutConstraint.activate([
            assigneeTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16), // 상단 여백
            assigneeTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16), // 하단 여백
            assigneeTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16), // 좌측 여백
            assigneeTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16) // 우측 여백
        ])
    }

}

// MARK: - UITableView DataSource & Delegate

extension AssigneeSelectionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assigneeList.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUser = assigneeList[indexPath.row]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = assigneeTableView.dequeueReusableCell(withIdentifier: CellIdentifier.assigneeCellIdentifier.rawValue, for: indexPath)
                as? AssigneeTableViewCell else {
            return UITableViewCell()
        }

        let assignee = assigneeList[indexPath.row]
        let name = assignee.login
        let url = assignee.avatarUrl
        cell.configureCell(name: name, image: UIImage(named: "dog") ?? UIImage())

        if let url = url {
            Task {
                do {
                    let image = try await downloadImage(url: url)
                    if tableView.indexPath(for: cell) == indexPath {
                        cell.configureCell(name: name, image: image)
                    }
                } catch {
                    print("\(NetworkError.downloadImageError)")
                }
            }
        }
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight * 1.5 {
            if !isLoading {
                isLoading = true
                viewModel.fetchAssignees(page: page)
            }
        }
    }

    private func downloadImage(url: String) async throws -> UIImage {
        guard let url = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidServerResponse
        }

        guard let image = UIImage(data: data) else {
            throw NetworkError.noData
        }
        return image
    }

}
