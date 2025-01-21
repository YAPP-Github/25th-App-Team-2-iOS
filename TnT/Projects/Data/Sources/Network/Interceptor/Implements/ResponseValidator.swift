//
//  ResponseValidator.swift
//  Data
//
//  Created by 박민서 on 1/21/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

struct ResponseValidatorInterceptor: Interceptor {
    let priority: InterceptorPriority = .normal

    func validate(response: URLResponse, data: Data) async throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown(statusCode: nil, message: "Invalid response")
        }

        let statusCode: Int = httpResponse.statusCode
        let responseBody: String = String(data: data, encoding: .utf8) ?? "No Response"

        switch statusCode {
        case 200..<300:
            return
        case 400:
            throw NetworkError.badRequest(message: responseBody)
            
        case 401:
            throw NetworkError.unauthorized(message: responseBody)
            
        case 403:
            throw NetworkError.forbidden(message: responseBody)
            
        case 404:
            throw NetworkError.notFound(message: responseBody)
            
        case 405..<500:
            throw NetworkError.clientError(statusCode: statusCode, message: responseBody)
            
        case 500..<600:
            throw NetworkError.serverError(statusCode: statusCode, message: responseBody)
            
        default:
            throw NetworkError.unknown(statusCode: statusCode, message: responseBody)
        }
    }
}
