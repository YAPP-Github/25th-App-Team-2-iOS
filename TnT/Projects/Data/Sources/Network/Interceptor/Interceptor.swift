//
//  Interceptor.swift
//  Data
//
//  Created by 박민서 on 1/21/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 인터셉터의 우선순위 정의
enum InterceptorPriority: Int, Comparable {
    case highest = 1  // 가장 높은 우선순위
    case high = 2
    case normal = 3  // 기본값
    case low = 4
    case lowest = 5  // 가장 낮은 우선순위

    static func < (lhs: InterceptorPriority, rhs: InterceptorPriority) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

/// 인터셉터 프로토콜
protocol Interceptor {
    /// 인터셉터의 우선순위
    var priority: InterceptorPriority { get }
    /// 요청 재수행 최대값
    var maxRetryCount: Int? { get }
    /// 요청을 변환하는 메서드 (예: 헤더 추가, URL 변경 등)
    /// - Parameter request: 변환할 `URLRequest`
    /// - Returns: 변환된 `URLRequest`
    /// - Throws: Interceptor에서 오류 발생 시 예외 처리
    func adapt(request: URLRequest) async throws -> URLRequest
    /// 응답을 검증하는 메서드 (예: HTTP 상태 코드 확인)
    /// - Parameters:
    ///   - response: 서버에서 반환된 `URLResponse`
    ///   - data: 서버에서 반환된 `Data`
    /// - Throws: 응답이 유효하지 않을 경우 예외 발생
    func validate(response: URLResponse, data: Data) async throws
    /// 재시도 여부를 결정하는 메서드
    /// - Parameters:
    ///   - request: 요청된 `URLRequest`
    ///   - error: 발생한 네트워크 오류
    ///   - attempt: 현재 재시도 횟수
    /// - Returns: 재시도 여부 (`true`이면 재시도 수행)
    /// - Throws: Interceptor에서 오류 발생 시 예외 처리
    func retry(request: URLRequest, dueTo error: Error, attempt: Int) async throws -> Bool
}

/// 기본 구현 제공 (옵션 메서드 역할)
extension Interceptor {
    var priority: InterceptorPriority { return .normal }
    var maxRetryCount: Int? { return nil }
    func adapt(request: URLRequest) async throws -> URLRequest { request }
    func validate(response: URLResponse, data: Data) async throws {}
    func retry(request: URLRequest, dueTo error: Error, attempt: Int) async throws -> Bool { false }
}

/// Hashable을 구현한 인터셉터 래퍼
/// 추후 인터셉터 캐싱을 위해 구현한 래퍼입니다
struct HashableInterceptor: Hashable {
    let interceptor: any Interceptor

    init(_ interceptor: any Interceptor) {
        self.interceptor = interceptor
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: type(of: interceptor)))
        
        let mirror: Mirror = Mirror(reflecting: interceptor)
        for (_, value) in mirror.children {
            if let hashableValue = value as? any Hashable {
                hasher.combine(hashableValue)
            }
        }
    }

    static func == (lhs: HashableInterceptor, rhs: HashableInterceptor) -> Bool {
        guard String(describing: type(of: lhs.interceptor)) == String(describing: type(of: rhs.interceptor)) else {
            return false
        }

        let lhsMirror: Mirror = Mirror(reflecting: lhs.interceptor)
        let rhsMirror: Mirror = Mirror(reflecting: rhs.interceptor)

        for ((_, lhsValue), (_, rhsValue)) in zip(lhsMirror.children, rhsMirror.children) {
            if let lhsEquatable = lhsValue as? any Equatable,
               let rhsEquatable = rhsValue as? any Equatable {
                if !(lhsEquatable as AnyObject).isEqual(rhsEquatable as AnyObject) {
                    return false
                }
            } else {
                return false
            }
        }
        return true
    }
}
