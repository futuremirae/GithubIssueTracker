//
//  AssigneeServiceImpl.swift
//  IssueTracker
//
//  Created by 이숲 on 10/14/24.
//

import Foundation
import Combine

final class AssigneeServiceImpl: AssigneeService {

    // MARK: - Properties

    private let baseURL = "\(APIEndpoints.githubApiURL)\(APIEndpoints.repos)"
    private let session: URLSession
    private let token: String

    // MARK: - Initializer

    init(session: URLSession = .shared, token: String) {
        self.session = session
        self.token = token
    }

    // MARK: - CRUD

    func fetchAssignees(page: Int, perPage: Int) -> AnyPublisher<[UserDTO], any Error> {
        let request = makeRequest(endpoint: "\(APIEndpoints.assignees)?page=\(page)&per_page=\(perPage)", method: .get)
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                try self.checkResponse(response: response)
                return try JSONDecoder().decode([UserDTO].self, from: data)
            }
            .eraseToAnyPublisher()
    }

}

private extension AssigneeServiceImpl {

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
