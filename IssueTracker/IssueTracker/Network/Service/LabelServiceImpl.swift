//
//  LabelServiceImpl.swift
//  IssueTracker
//
//  Created by 이숲 on 10/14/24.
//

import Foundation
import Combine

final class LabelServiceImpl: LabelService {

    // MARK: - Properties

    private let baseURL = "\(APIEndpoints.githubApiURL)\(APIEndpoints.repos)"
    private let session: URLSession = .shared
    private let token: String

    // MARK: - Initializer

    init(token: String) {
        self.token = token
    }

    // MARK: - CRUD

    func fetchLabels(page: Int, perPage: Int) -> AnyPublisher<[LabelDTO], any Error> {
        let request = makeRequest(endpoint: "\(APIEndpoints.labels)?page=\(page)&per_page=\(perPage)", method: .get)
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                try self.checkResponse(response: response)
                return try JSONDecoder().decode([LabelDTO].self, from: data)
            }
            .eraseToAnyPublisher()
    }

    func createLabel(label: LabelDTO) -> AnyPublisher<Void, Error> {
        let body = try? JSONEncoder().encode(label)
        let request = makeRequest(endpoint: "\(APIEndpoints.labels)", method: .post, body: body)
        return session.dataTaskPublisher(for: request)
            .tryMap { _, response in
                try self.checkResponse(response: response)
                return ()
            }
            .eraseToAnyPublisher()
    }

    func updateLabel(labelNumber: Int, updatedLabel: LabelDTO) -> AnyPublisher<Void, Error> {
        let body = try? JSONEncoder().encode(updatedLabel)
        let request = makeRequest(endpoint: "\(APIEndpoints.labels)/\(labelNumber)", method: .patch, body: body)
        return session.dataTaskPublisher(for: request)
            .tryMap { _, response in
                try self.checkResponse(response: response)
                return ()
            }
            .eraseToAnyPublisher()
    }

    func deleteLabel(labelName: String) -> AnyPublisher<Void, Error> {
        let request = makeRequest(endpoint: "\(APIEndpoints.labels)/\(labelName)", method: .delete)
        return session.dataTaskPublisher(for: request)
            .tryMap { _, response in
                try self.checkResponse(response: response)
                return ()
            }
            .eraseToAnyPublisher()
    }

}

private extension LabelServiceImpl {

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
