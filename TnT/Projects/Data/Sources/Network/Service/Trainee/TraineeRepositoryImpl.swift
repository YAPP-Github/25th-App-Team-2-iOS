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
    
    public func postConnectTrainer(_ reqDTO: PostConnectTrainerReqDTO) async throws -> PostConnectTrainerResDTO {
        return try await networkService.request(
            TraineeTargetType.postConnectTrainer(reqDto: reqDTO),
            decodingType: PostConnectTrainerResDTO.self
        )
    }
    
    public func postTraineeDietRecord(_ reqDTO: PostTraineeDietRecordReqDTO, imgData: Data?) async throws -> PostTraineeDietRecordResDTO {
        return try await networkService.request(TraineeTargetType.postTraineeDietRecord(reqDto: reqDTO, imgData: imgData), decodingType: PostTraineeDietRecordResDTO.self)
    }
    
    public func getActiveDateList(startDate: String, endDate: String) async throws -> GetActiveDateListResDTO {
        return try await networkService.request(TraineeTargetType.getActiveDateList(startDate: startDate, endDate: endDate), decodingType: GetActiveDateListResDTO.self)
    }
    
    public func getActiveDateDetail(date: String) async throws -> GetActiveDateDetailResDTO {
        return try await networkService.request(TraineeTargetType.getActiveDateDetail(date: date), decodingType: GetActiveDateDetailResDTO.self)
    }
    
    public func getDietRecordDetail(dietId: Int) async throws -> GetDietRecordDetailResDTO {
        return try await networkService.request(TraineeTargetType.getDietRecordDetail(dietId: dietId), decodingType: GetDietRecordDetailResDTO.self)
    }
}
