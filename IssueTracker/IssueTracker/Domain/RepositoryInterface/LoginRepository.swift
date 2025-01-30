//
//  LoginRepository.swift
//  IssueTracker
//
//  Created by 이숲 on 10/14/24.
//

import Foundation

protocol LoginRepository {
    func openGithubLoginPage()
    func setGithubAccessTokenInKeychain(with code: String) async throws
}
