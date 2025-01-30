//
//  LoginServiceImpl.swift
//  IssueTracker
//
//  Created by 이숲 on 10/14/24.
//

import Foundation
import UIKit

final class LoginServiceImpl: LoginService {

    // MARK: - Properties

    private let baseURL = "\(APIEndpoints.githubURL)"
    private let session: URLSession
    private let scope: String = "repo gist user"

    private let clientId = Token().clientId
    private let clientSecret = Token().clientSecret

    // MARK: - Initializer

    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Request Methods

    func openGithubLoginPage() {
        guard var components = URLComponents(string: baseURL+APIEndpoints.login) else { return }

        components.queryItems = [
            URLQueryItem(name: "client_id", value: Token().clientId),
            URLQueryItem(name: "scope", value: scope)
        ]

        let urlString = components.url?.absoluteString
        if let url = URL(string: urlString!), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    func setGithubAccessTokenInKeychain(with code: String) async throws {
        let request = try makeRequest(endpoint: "\(APIEndpoints.accessToken)", method: .post, code: code)

        let (data, response) = try await session.data(for: request)
        try checkResponse(response: response)
        let accessToken = try JSONDecoder().decode(AccessToken.self, from: data)
        try Keychain().set(account: "access_token", value: accessToken.accessToken)
        _ = try Keychain().get(account: "access_token")
    }
}

private extension LoginServiceImpl {

    func makeRequest(endpoint: String, method: HTTPMethod, code: String) throws -> URLRequest {
        var request = URLRequest(url: URL(string: "\(baseURL)\(endpoint)")!)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = [
            "client_id": clientId,
            "client_secret": clientSecret,
            "code": code
        ].map { "\($0.key)=\($0.value)" }.joined(separator: "&").data(using: .utf8)
        return request
    }

    func checkResponse(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidServerResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.statusCodeError
        }
    }

}
