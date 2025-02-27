//
//  AuthToken.swift
//  Data
//
//  Created by 박민서 on 1/21/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation
import Dependencies

/// 네트워크 요청에 인증 정보를 추가하는 인터셉터
struct AuthTokenInterceptor: Interceptor {
    let priority: InterceptorPriority = .highest

    func adapt(request: URLRequest) async throws -> URLRequest {
        var request: URLRequest = request
        guard let sessionId: String = try keyChainManager.read(for: .sessionId) else {
            return request
        }
        request.setValue("SESSION-ID \(sessionId)", forHTTPHeaderField: "Authorization")
        return request
    }
}
