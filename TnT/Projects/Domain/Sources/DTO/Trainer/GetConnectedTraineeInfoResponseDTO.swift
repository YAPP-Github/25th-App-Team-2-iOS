//
//  GetConnectedTraineeInfoResponseDTO.swift
//  Domain
//
//  Created by 박민서 on 2/11/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 연결 완료된 트레이니 정보 불러오기 응답 DTO
public struct GetConnectedTraineeInfoResponseDTO: Decodable {
    /// 연결 트레이니 DTO
    public let trainer: ConnectTrainerInfoDTO
    /// 연결 트레이너 DTO
    public let trainee: ConnectTraineeInfoDTO
}

public struct ConnectTrainerInfoDTO: Decodable {
    /// 트레이너 이름
    let trainerName: String
    /// 트레이너 프로필 이미지
    let trainerProfileImageUrl: String
}

public struct ConnectTraineeInfoDTO: Decodable {
    /// 트레이니 이름
    let traineeName: String
    /// 트레이니 프로필 이미지 url
    let traineeProfileImageUrl: String
    /// 나이
    let age: Int?
    /// 키
    let height: Double?
    /// 몸무게
    let weight: Double?
    /// PT 목표
    let ptGoal: String?
    /// 주의 사항
    let cautionNote: String?
}
