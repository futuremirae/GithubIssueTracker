//
//  TabBarController.swift
//  IssueTracker
//
//  Created by 이숲 on 10/8/24.
//

import UIKit

final class TabBarController: UITabBarController {

    // MARK: - TabBarView LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewAttributes()
        setupViewHierarchy()
        setupViewConstraints()
    }

}

// MARK: - UI Configure

private extension TabBarController {
    func setupViewAttributes() {
        setupTabBar()
    }

    func setupTabBar() {
        let appearanceTabbar = UITabBarAppearance()
        appearanceTabbar.configureWithOpaqueBackground()
        appearanceTabbar.backgroundColor = .systemBackground

        tabBar.standardAppearance = appearanceTabbar
    }

    func setupViewHierarchy() {
        viewControllers = [
            createNavController(for: IssueListViewBuilder().build(), title: "이슈", image: UIImage(systemName: "exclamationmark.circle")),
            createNavController(for: LabelListViewBuilder().build(), title: "레이블", image: UIImage(systemName: "tag")),
            createNavController(for: MilestoneListViewBuilder().build(), title: "마일스톤", image: UIImage(systemName: "signpost.right")),
            createNavController(for: UIViewController(), title: "내 계정", image: UIImage(systemName: "person.circle"))
        ]
    }

    func setupViewConstraints() {

    }

}

// MARK: - TabBar Navigation Controller

private extension TabBarController {

    func createNavController(for rootViewController: UIViewController, title: String?, image: UIImage?) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.backgroundColor = .systemBackground
        navController.navigationBar.prefersLargeTitles = true

        navController.tabBarItem.title = title
        navController.tabBarItem.image = image

        navController.interactivePopGestureRecognizer?.delegate = nil

        return navController
    }

}
