//
//  ResponseValidatorInterceptor.swift
//  Data
//
//  Created by 박민서 on 1/21/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

struct ResponseValidatorInterceptor: Interceptor {
    let priority: InterceptorPriority = .low

    func validate(response: URLResponse, data: Data) async throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown(statusCode: nil, message: "Invalid response")
        }

        let statusCode = httpResponse.statusCode
        let responseBody = String(data: data, encoding: .utf8)

        switch statusCode {
        case 200..<300:
            return

        case 400..<500:
            if statusCode == 401 {
                throw NetworkError.unauthorized
            } else if statusCode == 403 {
                throw NetworkError.forbidden
            } else if statusCode == 404 {
                throw NetworkError.notFound
            } else {
                throw NetworkError.clientError(statusCode: statusCode, message: responseBody)
            }

        case 500..<600:
            throw NetworkError.serverError(statusCode: statusCode, message: responseBody)

        default:
            throw NetworkError.unknown(statusCode: statusCode, message: responseBody)
        }
    }
}
