//
//  NetWorkError.swift
//  IssueTracker
//
//  Created by 김미래 on 9/29/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case statusCodeError
    case invalidServerResponse
    case downloadImageError
    case keychainError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL 주소입니다."
        case .noData:
            return "데이터가 존재하지 않습니다."
        case .statusCodeError:
            return "잘못된 응답입니다."
        case .invalidServerResponse:
            return "상태코드 에러(200이 아닙니다.)"
        case .downloadImageError:
            return "이미지 다운에 실패했습니다."
        case .keychainError:
            return "Keychain 에러"
        }
    }
}
