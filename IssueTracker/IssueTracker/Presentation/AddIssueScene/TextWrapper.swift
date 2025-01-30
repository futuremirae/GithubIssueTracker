//
// TextWrapper.swift
// IssueTracker
//
// Created by 김미래 on 10/14/24.
//

import SwiftUI

struct TextWrapper: UIViewRepresentable {

    @Binding var text: String
    var insertPhotoCallback: (() -> Void)?

    class Coordinator: NSObject, UITextViewDelegate {

        var parent: TextWrapper

        init(parent: TextWrapper) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }

        func textView(_ textView: UITextView, editMenuForTextIn range: NSRange, suggestedActions: [UIMenuElement]) -> UIMenu? {
            let insertPhotoAction = UIAction(title: "insert Photo") { [weak self] _ in
                self?.parent.insertPhotoCallback?()
            }
            var actions = suggestedActions
            actions.append(insertPhotoAction)
            return UIMenu(children: actions)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = CustomTextView()
        textView.isUserInteractionEnabled = true
        textView.delegate = context.coordinator
        textView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textView.heightAnchor.constraint(equalToConstant: 200)
        ])

        return textView
    }

    func updateUIView(_ textView: UITextView, context: Context) {
        if textView.text != text {
            textView.text = text
        }
    }

}

final class CustomTextView: UITextView, UIEditMenuInteractionDelegate {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private func configure() {
        self.font = .systemFont(ofSize: 17)
        self.isScrollEnabled = false
    }

}
