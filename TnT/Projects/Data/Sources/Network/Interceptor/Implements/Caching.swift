//
//  Caching.swift
//  Data
//
//  Created by 박민서 on 1/21/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 네트워크 요청 캐싱을 처리하는 인터셉터
struct CachingInterceptor: Interceptor {
    let priority: InterceptorPriority = .low
    let shouldForceRefresh: Bool
    
    /// 초기화
    /// - Parameter shouldForceRefresh: `true`이면 캐싱을 무시하고 강제 로드
    init(shouldForceRefresh: Bool = false) {
        self.shouldForceRefresh = shouldForceRefresh
    }

    func adapt(request: URLRequest) async throws -> URLRequest {
        var request: URLRequest = request

        // GET 요청에 대해서만 캐싱 정책을 적용합니다
        guard request.httpMethod == HTTPMethod.get.rawValue else {
            return request
        }
        
        request.cachePolicy = shouldForceRefresh ? .reloadIgnoringLocalCacheData : .returnCacheDataElseLoad
        return request
    }
}

// MARK: Hashable & Equatable
extension CachingInterceptor {
    func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: type(of: self)))
        hasher.combine(shouldForceRefresh)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return String(describing: type(of: lhs)) == String(describing: type(of: rhs)) &&
        lhs.shouldForceRefresh == rhs.shouldForceRefresh
    }
}
