//
//  TraineeUseCase.swift
//  Domain
//
//  Created by 박민서 on 1/26/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

// MARK: - TraineeUseCase 프로토콜
public protocol TraineeUseCase {
    /// 입력 초대 코드 검증
    func validateInvitationCode(_ code: String) -> Bool
    
    // MARK: API Call
    /// API Call - 트레이너 초대 코드 인증 API 호출
    func verifyTrainerInvitationCode(_ code: String) async throws -> Bool
}

// MARK: - Default 구현체
public struct DefaultTraineeUseCase: TraineeUseCase {
    private let trainerRepository: TrainerRepository
    
    public init(trainerRepository: TrainerRepository) {
        self.trainerRepository = trainerRepository
    }
    
    public func validateInvitationCode(_ code: String) -> Bool {
        return !code.isEmpty && UserPolicy.invitationInput.textValidation(code)
    }
    
    public func verifyTrainerInvitationCode(_ code: String) async throws -> Bool {
        let result = try await trainerRepository.getVerifyInvitationCode(code: code)
        return result.isVerified
    }
}
