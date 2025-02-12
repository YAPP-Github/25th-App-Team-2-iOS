//
//  TrainerResponseDTO.swift
//  Domain
//
//  Created by 박민서 on 1/26/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 초대코드 인증하기 응답 DTO
public struct GetVerifyInvitationCodeResDTO: Decodable {
    /// 초대 코드 인증 여부
    public let isVerified: Bool
    /// 트레이너 이름
    public let trainerName: String?
}

/// 달력 스케줄 카운트 표시에 필요한 PT 리스트 불러오기 응답 DTO
public struct GetMonthlyLessonListResDTO: Decodable {
    public let calendarPtLessonCounts: [DailyLessonCountResDTO]
}

/// 일별 스케줄 카운트 표시용 응답 DTO
public struct DailyLessonCountResDTO: Decodable {
    public let date: String
    public let count: Int
}

/// 관리 중인 회원 목록 응답 DTO
public struct GetActiveTraineesListResDTO: Decodable {
    public let trainees: [ActiveTraineeInfoResDTO]
}

/// 관리 중인 회원 정보 DTO
public struct ActiveTraineeInfoResDTO: Decodable {
    public let id: Int
    public let name: String
    public let profileImageUrl: String
    public let finishedPtCount: Int
    public let totalPtCount: Int
    public let memo: String
    public let ptGoals: [String]
}

/// PT 수업 추가 응답 DTO
public typealias PostLessonResDTO = EmptyResponse

/// PT 수업 완료 처리 응답 DTO
public typealias PutCompleteLessonResDTO = EmptyResponse
