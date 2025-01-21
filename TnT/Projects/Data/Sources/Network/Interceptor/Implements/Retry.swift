//
//  Retry.swift
//  Data
//
//  Created by 박민서 on 1/21/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 네트워크 요청 재시도를 처리하는 인터셉터
struct RetryInterceptor: Interceptor {
    let priority: InterceptorPriority = .lowest
    let maxRetryCount: Int
    
    // 재시도가 필요한 네트워크 오류 목록
    let retryableErrors: Set<URLError.Code> = [
        .timedOut,
        .networkConnectionLost,
        .cannotFindHost,
        .cannotConnectToHost,
        .notConnectedToInternet
    ]
    
    /// 초기화 메서드
    /// - Parameter maxRetryCount: 최대 재시도 횟수 (기본값: 3)
    init(maxRetryCount: Int = 3) {
        self.maxRetryCount = maxRetryCount
    }
    
    func retry(request: URLRequest, dueTo error: Error, attempt: Int) async throws -> Bool {
        if attempt >= maxRetryCount { return false }
        guard let urlError = error as? URLError, retryableErrors.contains(urlError.code) else { return false }
        return true
    }
}

// MARK: Hashable & Equatable
extension RetryInterceptor {
    func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: type(of: self)))
        hasher.combine(maxRetryCount)
    }
    
    static func == (lhs: RetryInterceptor, rhs: RetryInterceptor) -> Bool {
        return String(describing: type(of: lhs)) == String(describing: type(of: rhs)) &&
        lhs.maxRetryCount == rhs.maxRetryCount
    }
}
