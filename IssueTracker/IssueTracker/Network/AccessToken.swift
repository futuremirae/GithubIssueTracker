//
//  AccessToken.swift
//  IssueTracker
//
//  Created by 이숲 on 10/17/24.
//

struct AccessToken: Decodable {
    let tokenType: String
    let accessToken: String
    let scope: String

    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case accessToken = "access_token"
        case scope
    }
}
