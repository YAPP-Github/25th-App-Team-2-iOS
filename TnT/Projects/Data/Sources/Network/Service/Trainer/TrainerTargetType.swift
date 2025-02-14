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
    /// 달력 스케줄 카운트 표시에 필요한 PT 리스트 불러오기
    case getMonthlyLessonList(year: Int, month: Int)
    /// 트레이너 초대코드 재발급
    case putReissuanceInvitationCode
    /// 회원 조희
    case getMemebersList
    /// 연결 완료된 트레이니 최초로 정보 불러오기
    case getConnectedTraineeInfo(trainerId: Int64, traineeId: Int64)
    /// 관리 중인 회원 목록 요청
    case getActiveTraineesList
    /// PT 수업 추가
    case postLesson(reqDTO: PostLessonReqDTO)
    /// PT 수업 완료 처리
    case putCompleteLesson(lessonId: Int)
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
        case .getMonthlyLessonList:
            return "/lessons/calendar"
        case .putReissuanceInvitationCode:
            return "/invitation-code/reissue"
        case .getMemebersList:
            return "/members"
        case .getConnectedTraineeInfo:
            return "/first-connected-trainee"
        case .getActiveTraineesList:
            return "/active-trainees"
        case .postLesson:
            return "lessons"
        case .putCompleteLesson(let lessonId):
            return "lessons/\(lessonId)/complete"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getVerifyInvitationCode, .getFirstInvitationCode, .getDateLessonList, .getMemebersList, .getConnectedTraineeInfo, .getMonthlyLessonList, .getActiveTraineesList:
            return .get
            
        case .putReissuanceInvitationCode, .putCompleteLesson:
            return .put
            
        case .postLesson:
            return .post
        }
    }
    
    var task: RequestTask {
        switch self {
        case .getVerifyInvitationCode, .getFirstInvitationCode, .getDateLessonList, .putReissuanceInvitationCode, .getMemebersList, .getActiveTraineesList, .putCompleteLesson:
            return .requestPlain
            
        case let .getMonthlyLessonList(year, month):
            return .requestParameters(parameters: [
                "year": year,
                "month": month
            ], encoding: .url)
            
        case let .getConnectedTraineeInfo(trainerId, traineeId):
            return .requestParameters(parameters: [
                "trainerId": trainerId,
                "traineeId": traineeId
            ], encoding: .url)
            
        case .postLesson(let reqDTO):
            return .requestJSONEncodable(encodable: reqDTO)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getVerifyInvitationCode, .getDateLessonList, .putReissuanceInvitationCode, .getMemebersList, .getMonthlyLessonList, .postLesson, .getActiveTraineesList:
            return ["Content-Type": "application/json"]
            
        case .getFirstInvitationCode, .getConnectedTraineeInfo, .putCompleteLesson:
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
