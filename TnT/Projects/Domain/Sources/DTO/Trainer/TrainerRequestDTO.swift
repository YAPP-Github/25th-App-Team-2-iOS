//
//  TrainerRequestDTO.swift
//  Domain
//
//  Created by 박민서 on 1/26/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 수업 추가 요청 시 사용되는 DTO
public struct PostLessonReqDTO: Encodable {
    /// 시작 시각
    let start: String
    /// 종료 시각
    let end: String
    /// 트레이니 id
    let traineeId: Int
}
