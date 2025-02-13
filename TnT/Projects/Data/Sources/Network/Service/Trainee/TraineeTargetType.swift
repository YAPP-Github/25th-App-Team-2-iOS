//
//  TraineeTargetType.swift
//  Data
//
//  Created by 박민서 on 1/27/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

import Domain

/// 트레이니 관련 API 요청 타입 정의
public enum TraineeTargetType {
    /// 트레이너 연결 요청
    case postConnectTrainer(reqDto: PostConnectTrainerReqDTO)
    /// 트레이니 식단 기록 작성
    case postTraineeDietRecord(reqDto: PostTraineeDietRecordReqDTO, imgData: Data?)
    /// 캘린더 수업, 기록 존재하는 날짜 조회
    case getActiveDateList(startDate: String, endDate: String)
    /// 특정 날짜 수업, 기록 조회
    case getActiveDateDetail(date: String)
    /// 특정 식단 조회
    case getDietRecordDetail(dietId: Int)
}

extension TraineeTargetType: TargetType {
    var baseURL: URL {
        let url: String = Config.apiBaseUrlDev + "/trainees"
        return URL(string: url)!
    }
    
    var path: String {
        switch self {
        case .postConnectTrainer:
            return "/connect-trainer"
        case .postTraineeDietRecord:
            return "/diets"
        case .getActiveDateList:
            return "/lessons/calendar"
        case .getActiveDateDetail(date: let date):
            return "/calendar/\(date)"
        case .getDietRecordDetail(dietId: let dietId):
            return "/diets/\(dietId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getActiveDateList, .getActiveDateDetail, .getDietRecordDetail:
            return .get
            
        case .postConnectTrainer, .postTraineeDietRecord:
            return .post
        }
    }
    
    var task: RequestTask {
        switch self {
        case .getActiveDateDetail, .getDietRecordDetail:
            return .requestPlain
            
        case let .getActiveDateList(startDate, endDate):
            return .requestParameters(parameters: [
                "startDate": startDate,
                "endDate": endDate
            ], encoding: .url)
            
        case .postConnectTrainer(let reqDto):
            return .requestJSONEncodable(encodable: reqDto)
            
        case let .postTraineeDietRecord(reqDto, imgData):
            let files: [MultipartFile] = imgData.map {
                [.init(fieldName: "dietImage", fileName: "dietImage.png", mimeType: "image/png", data: $0)]
            } ?? []
            
            return .uploadMultipart(
                jsons: [.init(jsonName: "request", json: reqDto)],
                files: files,
                additionalFields: [:]
            )
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .postConnectTrainer, .getActiveDateDetail, .getActiveDateList, .getDietRecordDetail:
            return ["Content-Type": "application/json"]
        case .postTraineeDietRecord:
            return ["Content-Type": "multipart/form-data"]
        }
    }
    
    var interceptors: [any Interceptor] {
        return [
            LoggingInterceptor(),
            AuthTokenInterceptor(),
            ProgressIndicatorInterceptor(),
            ResponseValidatorInterceptor(),
            RetryInterceptor(maxRetryCount: 2)
        ]
    }
}
