//
//  TrainerRepositoryImpl.swift
//  Data
//
//  Created by 박민서 on 1/26/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation
import Dependencies

import Domain

/// 트레이너 관련 네트워크 요청을 처리하는 TrainerRepository 구현체
public struct TrainerRepositoryImpl: TrainerRepository {
    private let networkService: NetworkService = .shared
    
    public init() {}
    
    public func getVerifyInvitationCode(code: String) async throws -> GetVerifyInvitationCodeResDTO {
        return try await networkService.request(
            TrainerTargetType.getVerifyInvitationCode(code: code),
            decodingType: GetVerifyInvitationCodeResDTO.self
        )
    }
}
