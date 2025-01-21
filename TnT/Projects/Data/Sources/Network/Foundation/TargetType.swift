//
//  TargetType.swift
//  Data
//
//  Created by 박민서 on 1/21/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 1. Moya의 `TargetType`과 유사한 프로토콜 정의
protocol TargetType {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var task: RequestTask { get }
    var headers: [String: String]? { get }
    var interceptorTypes: [Interceptor.Type] { get }
}

extension TargetType {
    var headers: [String: String]? { nil }
    var interceptorTypes: [Interceptor.Type] { [] }
}
