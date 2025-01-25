//
//  Logging.swift
//  Data
//
//  Created by 박민서 on 1/21/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation
import os.log

/// 네트워크 요청/응답을 로깅하는 인터셉터
struct LoggingInterceptor: Interceptor {
    let priority: InterceptorPriority = .highest
    let logger: Logger = Logger()

    func adapt(request: URLRequest) async throws -> URLRequest {
        logger.log("""
        🔹 [REQUEST START]
        - Time: \(Date())
        - URL: \(request.url?.absoluteString ?? "Unknown URL")
        - Method: \(request.httpMethod ?? "Unknown Method")
        - Headers: \(request.allHTTPHeaderFields ?? [:])
        - Body: \(request.httpBody.flatMap { String(data: $0, encoding: .utf8) } ?? "No Body")
        """)
        return request
    }

    func validate(response: URLResponse, data: Data) async throws {
        guard let httpResponse = response as? HTTPURLResponse else { return }
        logger.log("""
        ✅ [RESPONSE RECEIVED]
        - Time: \(Date())
        - URL: \(httpResponse.url?.absoluteString ?? "Unknown URL")
        - Status Code: \(httpResponse.statusCode)
        - Headers: \(httpResponse.allHeaderFields)
        - Body: \(String(data: data, encoding: .utf8) ?? "No Body")
        """)
    }

    func retry(request: URLRequest, dueTo error: Error, attempt: Int) async throws -> Bool {
        logger.warning("""
        ⚠️ [RETRY ATTEMPT]
        - Attempt: \(attempt)
        - URL: \(request.url?.absoluteString ?? "Unknown URL")
        - Error: \(error.localizedDescription)
        """)
        return false
    }
}
