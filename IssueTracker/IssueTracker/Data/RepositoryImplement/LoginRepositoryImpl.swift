//
//  LoginRepositoryImpl.swift
//  IssueTracker
//
//  Created by 이숲 on 10/14/24.
//

import Foundation

final class LoginRepositoryImpl: LoginRepository {

    // MARK: - Properties

    private let loginService: LoginService

    // MARK: - Initializer

    init(loginService: LoginService) {
        self.loginService = loginService
    }

    func openGithubLoginPage() {
        loginService.openGithubLoginPage()
    }

    func setGithubAccessTokenInKeychain(with code: String) async throws {
        try await loginService.setGithubAccessTokenInKeychain(with: code)
    }
}
