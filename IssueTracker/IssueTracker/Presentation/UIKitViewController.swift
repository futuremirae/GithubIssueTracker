//
//  UIKitViewController.swift
//  IssueTracker
//
//  Created by 이숲 on 10/15/24.
//

import UIKit
import SwiftUI

struct UIKitViewController: UIViewControllerRepresentable {

    let viewController: UIViewController

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // 필요 시 업데이트 작업을 수행
    }

}
