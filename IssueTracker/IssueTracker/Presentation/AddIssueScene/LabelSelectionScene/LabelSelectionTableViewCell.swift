//
//  LabelTableViewCell.swift
//  IssueTracker
//
//  Created by 이숲 on 10/16/24.
//

import UIKit

final class LabelSelectionTableViewCell: UITableViewCell {

    // MARK: - UI Components

    private let labelTextField = UITextField()

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

    func configureCell(name: String, color: String) {
        labelTextField.backgroundColor = UIColor(hexCode: color)
        labelTextField.text = name
    }
}

private extension LabelSelectionTableViewCell {

    func setupViewAttributes() {
        setupLabelTextField()
    }

    func setupLabelTextField() {
        labelTextField.borderStyle = .roundedRect
        labelTextField.textColor = .systemBackground
        labelTextField.textAlignment = .center
        labelTextField.font = .systemFont(ofSize: 20)

        labelTextField.isUserInteractionEnabled = false
    }

    func setupViewHierarchy() {
        [
            labelTextField
        ].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        })
    }

    func setupViewConstraints() {
        NSLayoutConstraint.activate([
            labelTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelTextField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelTextField.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
