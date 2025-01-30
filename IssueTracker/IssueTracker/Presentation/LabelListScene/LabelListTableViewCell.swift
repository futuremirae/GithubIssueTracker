//
//  LabelListTableViewCell.swift
//  IssueTracker
//
//  Created by 김미래 on 10/16/24.
//

import UIKit


final class LabelListTableViewCell: UITableViewCell {

    // MARK: - UI Components

    private let labelTextField = UITextField()
    private let descriptionTextField = UITextField()

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white

        setupViewAttributes()
        setupViewHierarchy()
        setupViewConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(name: String, color: String, description: String) {
        labelTextField.backgroundColor = UIColor(hexCode: color)
        labelTextField.text = name
        descriptionTextField.text = description

    }
}

private extension LabelListTableViewCell {

    func setupViewAttributes() {
        setupLabelTextField()
        setupdescriptionTextField()
    }

    func setupLabelTextField() {
        labelTextField.borderStyle = .roundedRect
        labelTextField.textColor = .systemBackground
        labelTextField.textAlignment = .center
        labelTextField.font = .systemFont(ofSize: 20)
        labelTextField.isUserInteractionEnabled = false
    }

    func setupdescriptionTextField() {
        descriptionTextField.textColor = .gray
        descriptionTextField.isUserInteractionEnabled = false
        descriptionTextField.font = .systemFont(ofSize: 15)
    }

    func setupViewHierarchy() {
        [
            labelTextField,
            descriptionTextField
        ].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        })
    }

    func setupViewConstraints() {
        NSLayoutConstraint.activate([

            labelTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            labelTextField.heightAnchor.constraint(equalToConstant: 24),

            descriptionTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionTextField.topAnchor.constraint(equalTo: labelTextField.bottomAnchor, constant: 8),
            descriptionTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)

        ])
    }
}

