//
//  SceneDelegate.swift
//  IssueTracker
//
//  Created by 김미래 on 9/23/24.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        showLoginView(window: window)
        self.window = window
        window.makeKeyAndVisible()

    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        let code = url.absoluteString.components(separatedBy: "code=").last ?? ""

        Task {
            do {
                try await LoginUseCase(repository: LoginRepositoryImpl(loginService: LoginServiceImpl())).setGithubAccessTokenInKeychain(with: code)

                if let window = self.window {
                    showTabBarController(window: window)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

}

extension SceneDelegate {

    func showLoginView(window: UIWindow) {
        let loginView = LoginView(onLogin: { self.showTabBarController(window: window) })
        window.rootViewController = UIHostingController(rootView: loginView)
    }

    func showTabBarController(window: UIWindow) {
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController

    }

}
