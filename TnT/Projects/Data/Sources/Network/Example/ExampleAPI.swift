//
//  ExampleAPI.swift
//  Data
//
//  Created by 박민서 on 1/22/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

// MARK: - API 정의 (TargetType 활용)
enum ExampleAPI {
    case getUsers
    case getUserDetail(id: Int)
    case createUser(reqDTO: UserCreateRequestDTO)
    case uploadProfileImage(userID: Int, imageData: Data)
}

// MARK: - ExampleAPI의 TargetType 구현
extension ExampleAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.example.com")!
    }

    var path: String {
        switch self {
        case .getUsers:
            return "/users"
        case .getUserDetail(let id):
            return "/users/\(id)"
        case .createUser:
            return "/users"
        case .uploadProfileImage(let userID, _):
            return "/users/\(userID)/upload"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getUsers, .getUserDetail:
            return .get
        case .createUser:
            return .post
        case .uploadProfileImage:
            return .post
        }
    }

    var task: RequestTask {
        switch self {
        case .getUsers, .getUserDetail:
            return .requestPlain
            
        case .createUser(let dto):
            return .requestJSONEncodable(encodable: dto)
            
        case .uploadProfileImage(_, let imageData):
            return .uploadMultipart(
                files: [.init(fieldName: "profile", fileName: "profile.jpg", mimeType: "image/jpeg", data: imageData)],
                additionalFields: [:]
            )
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    var interceptors: [any Interceptor] {
        return [
            LoggingInterceptor(),
            AuthTokenInterceptor(),
            RetryInterceptor(maxRetryCount: 5)
        ]
    }
}
