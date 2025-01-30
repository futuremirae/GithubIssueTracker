//
//  searchViewController.swift
//  IssueTracker
//
//  Created by 김미래 on 10/1/24.
//

import UIKit

protocol SearchFilterTableViewDelegate: AnyObject {
  func didSelect(_ searchFilterTableView: UITableView, token: FilterToken<IssueEntity>)
}

final class SearchViewController: UIViewController {

  // MARK: - Properties

  private var issues: [IssueEntity]
  var filteredIssues: [IssueEntity] = []
  private var filterTokens: [[FilterToken<IssueEntity>]] = []
  private var isFiltering: Bool = false

  // MARK: - UI Components

  private var searchTableView = UITableView(frame: CGRect(x: 0, y: 0, width: 1, height: 1), style: .insetGrouped)

  // MARK: - Delegate

  weak var delegate: SearchFilterTableViewDelegate?

  // MARK: - Initializer

  init(issues: [IssueEntity]) {
    self.issues = issues
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - ViewController LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .clear
    setupViewAttributes()
    setupViewHierarchy()
    setupViewConstraints()

    filterTokens = createAllFilterToken()

  }

  // MARK: - Filtered Issue

  func filteredIssues(issues: [IssueEntity]) {
    isFiltering = true
    filteredIssues = issues
    searchTableView.reloadData()
  }

}

// MARK: - Create Token

private extension SearchViewController {

  func createAllFilterToken() -> [[FilterToken<IssueEntity>]] {
    let issueToken = createIssueToken()
    let assigneeToken = createAssigneeToken()
    let labelToken = createLabelToken()
    let mailestoneToken = createMilestoneToken()
    return [issueToken, assigneeToken, labelToken, mailestoneToken]
  }

  func createIssueToken() -> [FilterToken<IssueEntity>] {
    let title = "이슈"
    let icon = "doc"
    let issueToken: [FilterToken<IssueEntity>] = [
      FilterToken(title: title, description: "열린 이슈", icon: icon, conditon: { issue in issue.state == "open" }),
      FilterToken(title: title, description: "내가 작성한 이슈", icon: icon, conditon: { issue in issue.user?.login == "futuremirae" }),
      FilterToken(title: title, description: "내가 댓글을 남긴 이슈", icon: icon, conditon: { _ in return false }),
      FilterToken(title: title, description: "닫힌 이슈", icon: icon, conditon: { issue in issue.state == "closed" })
    ]

    return issueToken
  }
  
  func createAssigneeToken() -> [FilterToken<IssueEntity>] {
    let title = "담당자"
    let icon = "person"
    let assigneeToken: [FilterToken<IssueEntity>] = issues.map { issue in
      FilterToken(title: title, description: issue.user?.login ?? "", icon: icon, conditon: { issue in issue.assignees?.contains { user in user.login == issue.user?.login } ?? false })}
    return assigneeToken
  }

  func createLabelToken() -> [FilterToken<IssueEntity>] {
    let title = "레이블"
    let icon = "flag.fill"
    let labelToken: [FilterToken<IssueEntity>] = [
      FilterToken(title: title, description: "레이블 없음", icon: icon, conditon: { issue in issue.labels == nil}),
      FilterToken(title: title, description: "documentation", icon: icon, conditon: { issue in issue.labels?.contains { label in label.name == "documentation" } ?? false }),
      FilterToken(title: title, description: "bug", icon: icon, conditon: { issue in issue.labels?.contains { label in label.name == "bug" } ?? false })
    ]

    return labelToken
  }

  func createMilestoneToken() -> [FilterToken<IssueEntity>] {
    let title = "마일스톤"
    let icon = "figure.gymnastics"
    let milestoneToken: [FilterToken<IssueEntity>] = [
      FilterToken(title: title, description: "마일스톤 없음", icon: icon, conditon: { issue in issue.milestone == nil }),
      FilterToken(title: title, description: "그룹프로젝트 없음: 이슈트래커", icon: icon, conditon: { issue in issue.milestone != nil })
    ]

    return milestoneToken
  }

}

// MARK: - UI Configure

private extension SearchViewController {

  func setupViewAttributes() {
    setupSearchTableView()
  }

  func setupSearchTableView() {
    searchTableView.delegate = self
    searchTableView.dataSource = self


    searchTableView.register(IssueTableViewCell.self, forCellReuseIdentifier: CellIdentifier.issueCellIdentifier.rawValue)
    searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: CellIdentifier.searchCellIdentifier.rawValue)

    //        searchFilterTableView.reloadData()
  }

  func setupViewHierarchy() {
    [
      searchTableView
    ].forEach({
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    })
  }

  func setupViewConstraints() {
    NSLayoutConstraint.activate([
      searchTableView.topAnchor.constraint(equalTo: view.topAnchor),
      searchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      searchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      searchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }

}

// MARK: - UITableView DataSource & Delegate

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    1 + filterTokens.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return filteredIssues.count
    } else {
      return filterTokens[section - 1].count
    }
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if section == 0 && isFiltering {
      // 필터된 검색 결과를 표시하는 헤더
      let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
      let headerLabel = UILabel(frame: header.bounds)
      let resultCount = "\(filteredIssues.count)건의 검색 결과"
      headerLabel.text = resultCount
      headerLabel.textAlignment = .natural
      headerLabel.font = UIFont.systemFont(ofSize: 24)  // 원하는 폰트 크기
      header.addSubview(headerLabel)
      return header
    }
    return nil
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if isFiltering {
      return 30
    }
    return 0
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 {
      return ""
    } else {
      return filterTokens[section - 1][0].title
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      // 첫 번째 섹션에 필터된 이슈 표시

      let issue = filteredIssues[indexPath.row]

      guard let cell = tableView.dequeueReusableCell(withIdentifier: "issueCell", for: indexPath)
              as? IssueTableViewCell else {
        return UITableViewCell()
      }

      cell.configureCell(issue: issue)
      return cell
    } else {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
              as? SearchTableViewCell else {
        return UITableViewCell()
      }
      let title = filterTokens[indexPath.section - 1][indexPath.row].description
      let conditon = filterTokens[indexPath.section - 1][indexPath.row].conditon
      let count = issues.filter(conditon).count
      cell.configureCell(title: title, count: count)
      return cell

    }

  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section != 0 {
      let token = filterTokens[indexPath.section - 1 ][indexPath.row]
      delegate?.didSelect(tableView, token: token)
    }
  }

}
