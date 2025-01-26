//
//  TraineeRepositoryImpl.swift
//  Data
//
//  Created by 박민서 on 1/27/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation
import Dependencies

import Domain

/// 트레이니 관련 네트워크 요청을 처리하는 TraineeRepository 구현체
public struct TraineeRepositoryImpl: TraineeRepository {
    private let networkService: NetworkService = .shared
    
    public init() {}
    
    public func postConnectTrainer(_ info: TraineeConnectInfo) async throws -> PostConnectTrainerResDTO {
        let requestDTO = PostConnectTrainerReqDTO(
            invitationCode: info.invitationCode,
            startDate: info.startDate,
            totalPtCount: info.totalPtCount,
            finishedPtCount: info.finishedPtCount
        )
        
        return try await networkService.request(
            TraineeTargetType.postConnectTrainer(reqDto: requestDTO),
            decodingType: PostConnectTrainerResDTO.self
        )
    }
}
