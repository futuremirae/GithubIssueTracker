//
//  IssueTableViewCell.swift
//  IssueTracker
//
//  Created by 김미래 on 9/23/24.
//

import UIKit

final class IssueTableViewCell: UITableViewCell {

    // MARK: - UI Components

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let milestoneImageView = UIImageView()
    private let milestoneLabel = UILabel()
    private let labelStackView = UIStackView()

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator

        setupViewAttirbutes()
        setupViewHierarchy()
        setupViewConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.accessoryType = .disclosureIndicator

        setupViewAttirbutes()
        setupViewHierarchy()
        setupViewConstraints()
    }

    // MARK: - Cell Confiure

    func configureCell(issue: IssueEntity) {
        titleLabel.text = issue.title
        subtitleLabel.text = issue.body ?? "한 줄 설명"

        milestoneLabel.text = "\(issue.milestone?.title ?? "마일스톤")"
        drawLabels(labels: issue.labels ?? [])
    }

    func resetLabelStackView() {
        labelStackView.arrangedSubviews.forEach { view in
            labelStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }

    func drawLabels(labels: [LabelEntity]) {
        resetLabelStackView()

        labels.forEach {
            let textField = UITextField()
            textField.borderStyle = .roundedRect
            textField.backgroundColor = UIColor(hexCode: $0.color)

            textField.text = $0.name
            textField.textColor = .systemBackground
            textField.textAlignment = .center
            textField.font = .systemFont(ofSize: 10)

            textField.isUserInteractionEnabled = false
            textField.heightAnchor.constraint(equalToConstant: 15).isActive = true

            labelStackView.addArrangedSubview(textField)
        }
    }

}

// MARK: - UI Configure

private extension IssueTableViewCell {

    func setupViewAttirbutes() {
        setupTitleLabel()
        setupSubtitleLabel()
        setupMilestoneImageView()
        setupMilestoneLabel()
        setupLabelStackView()
    }

    func setupTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 20)
    }

    func setupSubtitleLabel() {
        subtitleLabel.font = UIFont.systemFont(ofSize: 15)
        subtitleLabel.textColor = .gray
        subtitleLabel.numberOfLines = 1
    }

    func setupMilestoneImageView() {
        milestoneImageView.image = UIImage(systemName: "signpost.right")
        milestoneImageView.tintColor = .gray
    }

    func setupMilestoneLabel() {
        milestoneLabel.font = UIFont.systemFont(ofSize: 15)
        milestoneLabel.textColor = .gray
        milestoneLabel.numberOfLines = 1
    }

    func setupLabelStackView() {
        labelStackView.axis = .horizontal
        labelStackView.spacing = 8
    }

    func setupViewHierarchy() {
        [
            titleLabel,
            subtitleLabel,
            milestoneImageView,
            milestoneLabel,
            labelStackView
        ].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        })
    }

    func setupViewConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            milestoneImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            milestoneImageView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 4),
            milestoneImageView.widthAnchor.constraint(equalToConstant: 19),
            milestoneImageView.heightAnchor.constraint(equalToConstant: 20),

            milestoneLabel.leadingAnchor.constraint(equalTo: milestoneImageView.trailingAnchor, constant: 8),
            milestoneLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 4),
            milestoneLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            labelStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelStackView.topAnchor.constraint(equalTo: milestoneImageView.bottomAnchor, constant: 4),
            labelStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

}
