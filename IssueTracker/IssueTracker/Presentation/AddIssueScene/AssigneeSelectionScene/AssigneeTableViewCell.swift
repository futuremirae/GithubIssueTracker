//
//  AssigneeTableViewCell.swift
//  IssueTracker
//
//  Created by 김미래 on 9/25/24.
//

import UIKit

final class AssigneeTableViewCell: UITableViewCell {
    private let assigneeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dog")
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let assigneeNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20) // 적절한 폰트 크기 설정
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let checkPoint: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
        self.backgroundColor = .systemGray6
        contentView.addSubview(assigneeImage)
        contentView.addSubview(assigneeNameLabel)
        NSLayoutConstraint.activate([
            assigneeImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            assigneeImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            assigneeImage.widthAnchor.constraint(equalToConstant: 30), // 이미지 뷰의 너비 설정
            assigneeImage.heightAnchor.constraint(equalToConstant: 30), // 이미지 뷰의 높이 설정

            assigneeNameLabel.leadingAnchor.constraint(equalTo: assigneeImage.leadingAnchor, constant: 40),
            assigneeNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            assigneeNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // 상하 제약 조건 설정 (명확한 높이 계산을 위해 추가)
            assigneeNameLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8),
            assigneeNameLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }

    func configureCell(name: String, image: UIImage) {
        assigneeNameLabel.text = name
        assigneeImage.image = image
    }
}
