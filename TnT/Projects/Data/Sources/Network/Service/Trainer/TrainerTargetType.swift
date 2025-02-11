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
    case getDateLessonList(date: String)
    /// 트레이너 초대코드 재발급
    case getReissuanceInvitationCode
    /// 회원 조희
    case getMemebersList
    /// 연결 완료된 트레이니 최초로 정보 불러오기
    case getConnectedTraineeInfo(trainerId: Int, traineeId: Int)
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
        case .getDateLessonList(let date):
            return "/lessons/\(date)"
        case .getReissuanceInvitationCode:
            return "/invitation-code/reissue"
        case .getMemebersList:
            return "/members"
        case .getConnectedTraineeInfo:
            return "/first-connected-trainee"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getVerifyInvitationCode:
            return .get
        case .getFirstInvitationCode:
            return .get
        case .getDateLessonList:
            return .get
        case .getReissuanceInvitationCode:
            return .put
        case .getMemebersList:
            return .get
        case .getConnectedTraineeInfo:
            return .get
        }
    }
    
    var task: RequestTask {
        switch self {
        case .getVerifyInvitationCode:
            return .requestPlain
        case .getFirstInvitationCode:
            return .requestPlain
        case .getDateLessonList:
            return .requestPlain
        case .getReissuanceInvitationCode:
            return .requestPlain
        case .getMemebersList:
            return .requestPlain
        case let .getConnectedTraineeInfo(trainerId, traineeId):
            return .requestParameters(parameters: [
                "trainerId": trainerId,
                "traineeId": traineeId
            ], encoding: .url)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getVerifyInvitationCode:
            return ["Content-Type": "application/json"]
        case .getFirstInvitationCode:
            return nil
        case .getDateLessonList:
            return ["Content-Type": "application/json"]
        case .getReissuanceInvitationCode:
            return ["Content-Type": "application/json"]
        case .getMemebersList:
            return ["Content-Type": "application/json"]
        case .getConnectedTraineeInfo:
            return nil
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
