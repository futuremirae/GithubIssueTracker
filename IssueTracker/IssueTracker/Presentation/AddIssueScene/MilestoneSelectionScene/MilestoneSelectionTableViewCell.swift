//
//  MilestoneTableViewCell.swift
//  IssueTracker
//
//  Created by 이숲 on 10/16/24.
//

import UIKit

final class MilestoneSelectionTableViewCell: UITableViewCell {

    // MARK: - UI Components

    private let milestoneLabel = UILabel()

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemGray6

        setupViewAttributes()
        setupViewHierarchy()
        setupViewConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: -

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }

    func configureCell(name: String) {
        milestoneLabel.text = name
    }
}

private extension MilestoneSelectionTableViewCell {

    func setupViewAttributes() {
        setupMilestoneTextField()
    }

    func setupMilestoneTextField() {
        milestoneLabel.font = UIFont.systemFont(ofSize: 20)
    }

    func setupViewHierarchy() {
        [
            milestoneLabel
        ].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        })
    }

    func setupViewConstraints() {
        NSLayoutConstraint.activate([
            milestoneLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            milestoneLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            milestoneLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
