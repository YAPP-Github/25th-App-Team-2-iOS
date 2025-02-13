//
//  TraineeResponseDTO.swift
//  Domain
//
//  Created by 박민서 on 1/27/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 트레이너 연결 응답 DTO
public struct PostConnectTrainerResDTO: Decodable {
    /// 트레이너 이름
    public let trainerName: String
    /// 트레이니 이름
    public let traineeName: String
    /// 트레이너 프로필 이미지 URL
    public let trainerProfileImageUrl: String
    /// 트레이니 프로필 이미지 URL
    public let traineeProfileImageUrl: String
}

/// 트레이니 식단 기록 응답 DTO
public typealias PostTraineeDietRecordResDTO = EmptyResponse

/// 트레이니 캘린더 수업/기록 존재 날짜 조회 응답 DTO
public struct GetActiveDateListResDTO: Decodable {
    public let ptLessonDates: [String]
}

/// 특정 날짜 수업/기록 조회 응답 DTO
public struct GetActiveDateDetailResDTO: Decodable {
    public let date: String
    public let ptInfo: PTInfoResDTO?
    public let diets: [DietResDTO]
}

/// PT 정보에 사용되는 PTInfoResDTO
public struct PTInfoResDTO: Decodable {
    /// 트레이너 이름
    public let trainerName: String
    /// 세션 회차
    public let session: Int
    /// 수업 시작 시간
    public let lessonStart: String
    /// 수업 종료 시간
    public let lessonEnd: String
}

/// 식단 정보에 사용되는 DietResDTO
public struct DietResDTO: Decodable {
    /// 식단 ID
    public let dietId: Int
    /// 식단 시간
    public let date: String
    /// 식단 이미지 URL
    public let dietImageUrl: String?
    /// 식단 타입
    public let dietType: DietTypeResDTO
    /// 식단 메모
    public let memo: String
}

/// Breakfast, lunch, dinner, snack으로 구분되는 DietTypeResDTO
public enum DietTypeResDTO: String, Decodable {
    case breakfast = "BREAKFAST"
    case lunch = "LUNCH"
    case dinner = "DINNER"
    case snack = "SNACK"
    case unknown = ""
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = DietTypeResDTO(rawValue: rawValue) ?? .unknown
    }
}

/// 특정 식단 조회 응답 DTO
public typealias GetDietRecordDetailResDTO = DietResDTO
