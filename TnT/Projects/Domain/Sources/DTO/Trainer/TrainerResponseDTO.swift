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
