//
//  NetworkError.swift
//  Data
//
//  Created by 박민서 on 1/21/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// Status Code 기반 네트워크 에러 정의
enum NetworkError: Error {
    case clientError(statusCode: Int, message: String?) // 400 ~ 499
    case serverError(statusCode: Int, message: String?) // 500 ~ 599
    case unauthorized // 401
    case forbidden // 403
    case notFound // 404
    case timeout // 요청 시간 초과
    case noInternet // 네트워크 연결 없음
    case decodingError // 디코딩 실패
    case unknown(statusCode: Int?, message: String?) // 알 수 없는 오류
}
