//
//  MilestoneTableViewCell.swift
//  IssueTracker
//
//  Created by 이숲 on 10/16/24.
//

import UIKit

final class MilestoneTableViewCell: UITableViewCell {

    // MARK: - UI Components

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let progressLabel = UILabel()

    private let dueDateImageView = UIImageView()
    private let dueDateLabel = UILabel()

    private let openIssuesImageView = UIImageView()
    private let openIssuesLabel = UILabel()

    private let closedIssuesImageView = UIImageView()
    private let closedIssuesLabel = UILabel()

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViewAttirbutes()
        setupViewHierarchy()
        setupViewConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupViewAttirbutes()
        setupViewHierarchy()
        setupViewConstraints()
    }

    // MARK: - Cell Confiure

    func configureCell(milestone: MilestoneEntity) {
        titleLabel.text = milestone.title
        subtitleLabel.text = milestone.description

        if subtitleLabel.text != nil {
            subtitleLabel.isHidden = false
        }

        let openIssues = Double(milestone.openIssues ?? 0)
        let closedIssues = Double(milestone.closedIssues ?? 0)
        let total = Double(openIssues + closedIssues)

        if total != 0 {
            progressLabel.text = "\(Int(round(closedIssues / total * 100)))%"
        }

        dueDateLabel.text = "완료일 \(milestone.dueDate ?? "No due date")"
        openIssuesLabel.text = "열린 이슈 \(Int(openIssues))"
        closedIssuesLabel.text = "닫힌 이슈 \(Int(closedIssues))"
    }

}

// MARK: - UI Configure

private extension MilestoneTableViewCell {

    func setupViewAttirbutes() {
        setupTitleLabel()
        setupSubtitleLabel()
        setupProgressLabel()

        setupDueDateImageView()
        setupDueDateLabel()

        setupOpenIssuesImageView()
        setupOpenIssuesLabel()

        setupClosedIssuesImageView()
        setupClosedIssuesLabel()
    }

    func setupTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.numberOfLines = 1
    }

    func setupSubtitleLabel() {
        subtitleLabel.font = UIFont.systemFont(ofSize: 15)
        subtitleLabel.numberOfLines = 1
        subtitleLabel.isHidden = true
    }

    func setupProgressLabel() {
        progressLabel.font = UIFont.systemFont(ofSize: 20)
        progressLabel.textColor = .systemBlue
        progressLabel.textAlignment = .right
        progressLabel.text = "0%"
    }

    func setupDueDateImageView() {
        dueDateImageView.image = UIImage(systemName: "calendar")
        dueDateImageView.tintColor = .gray
    }

    func setupDueDateLabel() {
        dueDateLabel.font = UIFont.systemFont(ofSize: 15)
        dueDateLabel.textColor = .gray
        dueDateLabel.numberOfLines = 1
    }

    func setupOpenIssuesImageView() {
        openIssuesImageView.image = UIImage(systemName: "exclamationmark.circle.fill")
        openIssuesImageView.tintColor = .gray
    }

    func setupOpenIssuesLabel() {
        openIssuesLabel.font = UIFont.systemFont(ofSize: 13)
        openIssuesLabel.textColor = .gray
        openIssuesLabel.text = "열린 이슈 0"
        openIssuesLabel.numberOfLines = 1
    }

    func setupClosedIssuesImageView() {
        closedIssuesImageView.image = UIImage(systemName: "archivebox.fill")
        closedIssuesImageView.tintColor = .gray
    }

    func setupClosedIssuesLabel() {
        closedIssuesLabel.font = UIFont.systemFont(ofSize: 13)
        closedIssuesLabel.textColor = .gray
        closedIssuesLabel.text = "닫힌 이슈 0"
        closedIssuesLabel.numberOfLines = 1
    }

    func setupViewHierarchy() {
        [
            titleLabel,
            subtitleLabel,
            progressLabel,
            dueDateImageView,
            dueDateLabel,
            openIssuesImageView,
            openIssuesLabel,
            closedIssuesImageView,
            closedIssuesLabel
        ].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        })
    }

    func setupViewConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: progressLabel.leadingAnchor, constant: -16),

            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            progressLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            progressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            progressLabel.widthAnchor.constraint(equalToConstant: 60),

            dueDateImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dueDateImageView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 4),
            dueDateImageView.widthAnchor.constraint(equalToConstant: 19),

            dueDateLabel.leadingAnchor.constraint(equalTo: dueDateImageView.trailingAnchor, constant: 8),
            dueDateLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 4),
            dueDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            openIssuesImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            openIssuesImageView.topAnchor.constraint(equalTo: dueDateLabel.bottomAnchor, constant: 4),
            openIssuesImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            openIssuesImageView.widthAnchor.constraint(equalToConstant: 19),
            openIssuesImageView.heightAnchor.constraint(equalToConstant: 20),

            openIssuesLabel.leadingAnchor.constraint(equalTo: openIssuesImageView.trailingAnchor, constant: 8),
            openIssuesLabel.topAnchor.constraint(equalTo: dueDateLabel.bottomAnchor, constant: 4),
            openIssuesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            closedIssuesImageView.leadingAnchor.constraint(equalTo: openIssuesLabel.trailingAnchor, constant: 16),
            closedIssuesImageView.topAnchor.constraint(equalTo: dueDateLabel.bottomAnchor, constant: 4),
            closedIssuesImageView.widthAnchor.constraint(equalToConstant: 19),
            closedIssuesImageView.heightAnchor.constraint(equalToConstant: 20),
            closedIssuesImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            closedIssuesLabel.leadingAnchor.constraint(equalTo: closedIssuesImageView.trailingAnchor, constant: 8),
            closedIssuesLabel.topAnchor.constraint(equalTo: dueDateLabel.bottomAnchor, constant: 4),
            closedIssuesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

}
