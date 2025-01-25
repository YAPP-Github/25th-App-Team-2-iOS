//
//  TargetType.swift
//  Data
//
//  Created by 박민서 on 1/21/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 네트워크 요청을 정의하는 프로토콜
/// - `Moya`의 `TargetType`과 유사한 구조로, API 요청을 명확하게 정의하는 역할을 합니다.
/// - 각 API 요청에 대해 `baseURL`, `path`, `method`, `task` 등을 설정할 수 있습니다.
protocol TargetType {
    /// API의 기본 URL
    /// - ex) `https://api.example.com`
    var baseURL: URL { get }
    /// **API 엔드포인트 경로**
    /// - `baseURL`에 추가되는 경로로, 요청을 보낼 특정 리소스를 정의합니다.
    /// - ex) `/users/login`, `/posts/1/comments`
    var path: String { get }
    /// **HTTP 요청 메서드**
    /// - ex) `.get`, `.post`, `.put`, `.delete`
    var method: HTTPMethod { get }
    /// **요청에 필요한 데이터 및 파라미터 설정**
    /// - `RequestTask`를 사용하여 요청의 형식을 정의합니다.
    /// - ex) `requestPlain`, `requestParameters`, `requestJSONEncodable`, `uploadMultipart`
    var task: RequestTask { get }
    /// **요청 시 추가할 HTTP 헤더**
    /// - 기본값은 `nil`이지만, 특정 요청에서는 `Authorization`, `Content-Type` 등을 추가 가능합니다.
    var headers: [String: String]? { get }
    /// **해당 요청에 적용할 `Interceptor` 목록**
    /// - `Interceptor`를 통해 로깅, 인증, 캐싱, 재시도 등의 기능을 적용 가능합니다.
    /// - 기본적으로 비어있으며, 필요할 경우 개별 API마다 적용할 수 있습니다.
    var interceptors: [any Interceptor] { get }
}

// MARK: - 기본 구현 제공
extension TargetType {
    var headers: [String: String]? { nil }
    var interceptors: [any Interceptor] { [] }
}
