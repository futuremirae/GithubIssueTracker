//
//  MilestoneServiceImpl.swift
//  IssueTracker
//
//  Created by 이숲 on 10/14/24.
//

import Foundation
import Combine

final class MilestoneServiceImpl: MilestoneService {

    // MARK: - Properties

    private let baseURL = "\(APIEndpoints.githubApiURL)\(APIEndpoints.repos)"
    private let session: URLSession = .shared
    private let token: String

    // MARK: - Initializer

    init(token: String) {
        self.token = token
    }

    // MARK: - CRUD

    func fetchMilestones(page: Int, perPage: Int) -> AnyPublisher<[MilestoneDTO], any Error> {
        let request = makeRequest(endpoint: "\(APIEndpoints.milestones)?page=\(page)&per_page=\(perPage)", method: .get)
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                try self.checkResponse(response: response)
                return try JSONDecoder().decode([MilestoneDTO].self, from: data)
            }
            .eraseToAnyPublisher()
    }

    func createMilestone(milestone: MilestoneDTO) -> AnyPublisher<Void, Error> {
        let body = try? JSONEncoder().encode(milestone)
        let request = makeRequest(endpoint: "\(APIEndpoints.milestones)", method: .post, body: body)
        return session.dataTaskPublisher(for: request)
            .tryMap { _, response in
                try self.checkResponse(response: response)
                return ()
            }
            .eraseToAnyPublisher()
    }

    func updateMilestone(milestoneNumber: Int, updatedMilestone: MilestoneDTO) -> AnyPublisher<Void, Error> {
        let body = try? JSONEncoder().encode(updatedMilestone)
        let request = makeRequest(endpoint: "\(APIEndpoints.milestones)/\(milestoneNumber)", method: .patch, body: body)
        return session.dataTaskPublisher(for: request)
            .tryMap { _, response in
                try self.checkResponse(response: response)
                return ()
            }
            .eraseToAnyPublisher()
    }

    func deleteMilestone(milestoneNumber: Int) -> AnyPublisher<Void, Error> {
        let request = makeRequest(endpoint: "\(APIEndpoints.milestones)/\(milestoneNumber)", method: .delete)
        return session.dataTaskPublisher(for: request)
            .tryMap { _, response in
                try self.checkResponse(response: response)
                return ()
            }
            .eraseToAnyPublisher()
    }

}

private extension MilestoneServiceImpl {

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
