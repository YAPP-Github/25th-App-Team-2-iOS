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
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .postConnectTrainer:
            return .post
        }
    }
    
    var task: RequestTask {
        switch self {
        case .postConnectTrainer(let reqDto):
            return .requestJSONEncodable(encodable: reqDto)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .postConnectTrainer:
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

