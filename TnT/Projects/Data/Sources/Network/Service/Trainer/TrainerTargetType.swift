//
//  TrainerTargetType.swift
//  Data
//
//  Created by 박민서 on 1/26/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

import Domain

/// 트레이너 관련 API 요청 타입 정의
public enum TrainerTargetType {
    /// 트레이너 초대코드 인증
    case getVerifyInvitationCode(code: String)
    /// 트레이너 초대코드 불러오기
    case getFirstInvitationCode
    /// 트레이너 캘린더, 특정 날짜의 PT 리스트 불러오기
    case getDateLessionList(date: String)
    /// 트레이너 초대코드 재발급
    case getReissuanceInvitationCode
    /// 회원 조희
    case getMemebersList
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
        case .getFirstInvitationCode:
            return "/invitation-code"
        case .getDateLessionList(let date):
            return "/lessions/\(date)"
        case .getReissuanceInvitationCode:
            return "/invitation-code/reissue"
        case .getMemebersList:
            return "/members"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getVerifyInvitationCode:
            return .get
        case .getFirstInvitationCode:
            return .get
        case .getDateLessionList:
            return .get
        case .getReissuanceInvitationCode:
            return .put
        case .getMemebersList:
            return .get
        }
    }
    
    var task: RequestTask {
        switch self {
        case .getVerifyInvitationCode:
            return .requestPlain
        case .getFirstInvitationCode:
            return .requestPlain
        case .getDateLessionList:
            return .requestPlain
        case .getReissuanceInvitationCode:
            return .requestPlain
        case .getMemebersList:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getVerifyInvitationCode:
            return ["Content-Type": "application/json"]
        case .getFirstInvitationCode:
            return nil
        case .getDateLessionList:
            return ["Content-Type": "application/json"]
        case .getReissuanceInvitationCode:
            return ["Content-Type": "application/json"]
        case .getMemebersList:
            return ["Content-Type": "application/json"]
        }
    }
    
    var interceptors: [any Interceptor] {
        return [
            LoggingInterceptor(),
            AuthTokenInterceptor(),
            ProgressIndicatorInterceptor(),
            ResponseValidatorInterceptor(),
            RetryInterceptor(maxRetryCount: 0)
        ]
    }
}
