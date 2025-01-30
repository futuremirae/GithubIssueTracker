//
//  searchTableViewCell.swift
//  IssueTracker
//
//  Created by 김미래 on 10/1/24.
//

import UIKit

final class SearchTableViewCell: UITableViewCell {

    // MARK: - UI Components

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViewAttibutes()
        setupViewHierarchy()
        setupViewConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupViewAttibutes()
        setupViewHierarchy()
        setupViewConstraints()
    }

    // MARK: - Cell Configure

    func configureCell(title: String, count: Int) {
        titleLabel.text = title
        subtitleLabel.text = String(count)
    }

}

// MARK: - UI Configure

private extension SearchTableViewCell {

    func setupViewAttibutes() {
        setupTitleLabel()
        setupSubtitleLabel()
    }

    func setupTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 20)
    }

    func setupSubtitleLabel() {
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .gray
        subtitleLabel.numberOfLines = 0
    }

    func setupViewHierarchy() {
        [
            titleLabel,
            subtitleLabel
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

            subtitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -30),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

}
