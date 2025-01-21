//
//  InterceptorPipeline.swift
//  Data
//
//  Created by 박민서 on 1/21/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 여러 Interceptor를 관리하는 파이프라인
struct InterceptorPipeline {
    private let interceptors: [any Interceptor]
    
    /// InterceptorPipeline 초기화 (중복 제거 후 우선순위 정렬)
    /// - Parameter interceptors: 적용할 Interceptor 목록
    init(interceptors: [any Interceptor]) {
        let uniqueInterceptors: [Interceptor] = InterceptorPipeline.removeDuplicates(of: interceptors)
        self.interceptors = InterceptorPipeline.sortedByPriority(of: uniqueInterceptors)
    }

    /// 요청을 변환하는 메서드 (예: 헤더 추가, URL 변경 등)
    /// - Parameter request: 변환할 `URLRequest`
    /// - Returns: 변환된 `URLRequest`
    /// - Throws: Interceptor에서 오류 발생 시 예외 처리
    func adapt(_ request: URLRequest) async throws -> URLRequest {
        var adaptedRequest: URLRequest = request
        for interceptor in interceptors {
            adaptedRequest = try await interceptor.adapt(request: adaptedRequest)
        }
        return adaptedRequest
    }

    /// 응답을 검증하는 메서드 (예: HTTP 상태 코드 확인)
    /// - Parameters:
    ///   - response: 서버에서 반환된 `URLResponse`
    ///   - data: 서버에서 반환된 `Data`
    /// - Throws: 응답이 유효하지 않을 경우 예외 발생
    func validate(_ response: URLResponse, data: Data) async throws {
        for interceptor in interceptors {
            try await interceptor.validate(response: response, data: data)
        }
    }

    /// 재시도 여부를 결정하는 메서드
    /// - Parameters:
    ///   - request: 요청된 `URLRequest`
    ///   - error: 발생한 네트워크 오류
    ///   - attempt: 현재 재시도 횟수
    /// - Returns: 재시도 여부 (`true`이면 재시도 수행)
    /// - Throws: Interceptor에서 오류 발생 시 예외 처리
    func shouldRetry(_ request: URLRequest, dueTo error: Error, attempt: Int) async throws -> Bool {
        for interceptor in interceptors where try await interceptor.retry(request: request, dueTo: error, attempt: attempt) {
            return true
        }
        return false
    }
}

// MARK: - Private Helpers
private extension InterceptorPipeline {
    /// 인터셉터의 중복을 제거합니다
    /// 해당 인터셉터의 타입+내부 설정이 같은 경우 제거됩니다
    /// - Parameter interceptors: 중복 제거할 Interceptor 배열
    /// - Returns: 중복이 제거된 Interceptor 배열
    static func removeDuplicates(of interceptors: [any Interceptor]) -> [any Interceptor] {
        let hashableInterceptors: [HashableInterceptor] = interceptors.map { HashableInterceptor($0) }
        return Array(Set(hashableInterceptors)).map { $0.interceptor }
    }
    
    /// 우선순위에 따라 정렬 (낮은 우선순위가 먼저 실행됨)
    /// - Parameter interceptors: 정렬할 Interceptor 배열
    /// - Returns: 우선순위 기준으로 정렬된 Interceptor 배열
    static func sortedByPriority(of interceptors: [any Interceptor]) -> [any Interceptor] {
        return interceptors.sorted {
            $0.priority == $1.priority
            ? String(describing: type(of: $0)) < String(describing: type(of: $1))
            : $0.priority < $1.priority
        }
    }
}

// MARK: - Additional
extension InterceptorPipeline {
    // Interceptor에서 최대 재시도 횟수 가져오기 (여러 개의 `RetryInterceptor`가 있는 경우 최대값 반환)
    /// - Returns: 최대 재시도 횟수 (`Int?` 타입)
    func getMaxRetryCount() -> Int? {
        return interceptors
            .compactMap { ($0 as? RetryInterceptor)?.maxRetryCount }
            .max()
    }
}
