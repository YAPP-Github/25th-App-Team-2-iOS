//
//  ProgressIndicator.swift
//  Data
//
//  Created by 박민서 on 2/9/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

import Domain

struct ProgressIndicatorInterceptor: Interceptor {
    let priority: InterceptorPriority = .normal
    
    func adapt(request: URLRequest) async throws -> URLRequest {
        NotificationCenter.default.postProgress(visible: true)
        return request
    }

    func validate(response: URLResponse, data: Data) async throws {
        NotificationCenter.default.postProgress(visible: false)
    }
}
