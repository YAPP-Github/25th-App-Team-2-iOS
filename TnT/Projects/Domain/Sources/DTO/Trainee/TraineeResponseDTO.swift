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
