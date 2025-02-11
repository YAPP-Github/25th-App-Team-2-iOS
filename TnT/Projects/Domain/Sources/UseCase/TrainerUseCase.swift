//
//  TrainerUseCase.swift
//  Domain
//
//  Created by 박서연 on 2/8/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

// MARK: - TrainerUseCase Default 구현체
public struct DefaultTrainerUseCase: TrainerRepository {
    
    private let trainerRepository: TrainerRepository
    
    public init (trainerRepository: TrainerRepository) {
        self.trainerRepository = trainerRepository
    }
    
    public func getVerifyInvitationCode(code: String) async throws -> GetVerifyInvitationCodeResDTO {
        return try await trainerRepository.getVerifyInvitationCode(code: code)
    }
    
    public func getTheFirstInvitationCode() async throws -> GetTheFirstInvitationCodeDTO {
        return try await trainerRepository.getTheFirstInvitationCode()
    }
    
    public func getReissuanceInvitationCode() async throws -> GetReissuanceInvitationCodeDTO {
        return try await trainerRepository.getReissuanceInvitationCode()
    }
    
    public func getDateSessionList(date: String) async throws -> GetDateSessionListDTO {
        return try await trainerRepository.getDateSessionList(date: date)
    }
    
    public func getMembersList() async throws -> GetMembersListDTO {
        return try await trainerRepository.getMembersList()
    }
    
    public func getConnectedTraineeInfo(trainerId: Int, traineeId: Int) async throws -> GetConnectedTraineeInfoResponseDTO {
        return try await trainerRepository.getConnectedTraineeInfo(trainerId: trainerId, traineeId: traineeId)
    }
}
