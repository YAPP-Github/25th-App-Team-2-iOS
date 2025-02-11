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
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .postConnectTrainer, .postTraineeDietRecord:
            return .post
        }
    }
    
    var task: RequestTask {
        switch self {
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
        case .postConnectTrainer:
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
