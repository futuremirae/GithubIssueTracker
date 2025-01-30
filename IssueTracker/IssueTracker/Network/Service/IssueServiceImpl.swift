//
//  IssueServiceImpl.swift
//  IssueTracker
//
//  Created by 이숲 on 10/12/24.
//

import Foundation
import Combine

final class IssueServiceImpl: IssueService {

    // MARK: - Properties

    private let baseURL = "\(APIEndpoints.githubApiURL)\(APIEndpoints.repos)"
    private let session: URLSession
    private let token: String // GitHub Access Token

    // MARK: - Initializer

    init(session: URLSession = .shared, token: String) {
        self.session = session
        self.token = token
    }

    // MARK: - CRUD

    func fetchIssues(page: Int, perPage: Int) -> AnyPublisher<[IssueDTO], Error> {
        let request = makeRequest(endpoint: "\(APIEndpoints.issues)?page=\(page)&per_page=\(perPage)", method: .get)
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                try self.checkResponse(response: response)
                return try JSONDecoder().decode([IssueDTO].self, from: data)
            }
            .eraseToAnyPublisher()
    }

    func createIssue(issue: RequestIssueDTO) -> AnyPublisher<Void, Error> {
        let body = try? JSONEncoder().encode(issue)
        let request = makeRequest(endpoint: "\(APIEndpoints.issues)", method: .post, body: body)
        return session.dataTaskPublisher(for: request)
            .tryMap { _, response in
                try self.checkResponse(response: response)
                return ()
            }
            .eraseToAnyPublisher()
    }

    func updateIssue(issueNumber: Int, updatedIssue: RequestIssueDTO) -> AnyPublisher<Void, Error> {
        let body = try? JSONEncoder().encode(updatedIssue)
        let request = makeRequest(endpoint: "\(APIEndpoints.issues)/\(issueNumber)", method: .patch, body: body)
        return session.dataTaskPublisher(for: request)
            .tryMap { _, response in
                try self.checkResponse(response: response)
                return ()
            }
            .eraseToAnyPublisher()
    }

    func deleteIssue(issueNumber: Int) -> AnyPublisher<Void, Error> {
        let request = makeRequest(endpoint: "\(APIEndpoints.issues)/\(issueNumber)", method: .delete)
        return session.dataTaskPublisher(for: request)
            .tryMap { _, response in
                try self.checkResponse(response: response)
                return ()
            }
            .eraseToAnyPublisher()
    }
}

private extension IssueServiceImpl {

    func makeRequest(endpoint: String, method: HTTPMethod, body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: URL(string: "\(baseURL)\(endpoint)")!)
        request.httpMethod = method.rawValue
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = body
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
