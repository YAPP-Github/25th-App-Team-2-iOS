//
//  TrainerTargetType.swift
//  Data
//
//  Created by 박민서 on 1/26/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

import Domain

/// 사용자 관련 API 요청 타입 정의
public enum TrainerTargetType {
    /// 트레이너 초대코드 인증
    case getVerifyInvitationCode(code: String)
}

extension TrainerTargetType: TargetType {
    var baseURL: URL {
        let url: String = Config.apiBaseUrlDev + "/trainers"
        return URL(string: url)!
    }
    
    var path: String {
        switch self {
        case .getVerifyInvitationCode(let code):
            return "/invitation-code/verify/\(code)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getVerifyInvitationCode:
            return .get
        }
    }
    
    var task: RequestTask {
        switch self {
        case .getVerifyInvitationCode:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getVerifyInvitationCode:
            return ["Content-Type": "application/json"]
        }
    }
    
    var interceptors: [any Interceptor] {
        return [
            LoggingInterceptor(),
            AuthTokenInterceptor(),
            ResponseValidatorInterceptor(),
            RetryInterceptor(maxRetryCount: 0)
        ]
    }
}
