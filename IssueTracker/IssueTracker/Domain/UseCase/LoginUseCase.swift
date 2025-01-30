//
//  LoginUseCase.swift
//  IssueTracker
//
//  Created by 이숲 on 10/14/24.
//

import Foundation

struct LoginUseCase {
    let repository: LoginRepository

    func openGithubLoginPage() {
        repository.openGithubLoginPage()
    }

    func setGithubAccessTokenInKeychain(with code: String) async throws {
        try await repository.setGithubAccessTokenInKeychain(with: code)
    }
}
