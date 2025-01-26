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
    /// 입력 PT 시작일 검증
    func validateStartDate(_ startDate: String) -> Bool
    /// PT 횟수 검증
    func validatePtCount(_ count: String) -> Bool
    
    // MARK: API Call
    /// API Call - 트레이너 초대 코드 인증 API 호출
    func verifyTrainerInvitationCode(_ code: String) async throws -> Bool
    /// API Call - 트레이니 - 트레이너 연결 API 호출
    func connectTrainer(_ info: TraineeConnectInfo) async throws -> ConnectionInfo
}

// MARK: - Default 구현체
public struct DefaultTraineeUseCase: TraineeUseCase {
    private let trainerRepository: TrainerRepository
    private let traineeRepository: TraineeRepository
    
    public init(trainerRepository: TrainerRepository, traineeRepository: TraineeRepository) {
        self.trainerRepository = trainerRepository
        self.traineeRepository = traineeRepository
    }
    
    public func validateInvitationCode(_ code: String) -> Bool {
        return !code.isEmpty && TraineePolicy.invitationInput.textValidation(code)
    }
    
    public func validateStartDate(_ startDate: String) -> Bool {
        return !startDate.isEmpty && TraineePolicy.startDateInput.textValidation(startDate)
    }
    
    public func validatePtCount(_ count: String) -> Bool {
        return !count.isEmpty && TraineePolicy.ptCountInput.textValidation(count)
    }
    
    // MARK: API Call
    public func verifyTrainerInvitationCode(_ code: String) async throws -> Bool {
        let result: GetVerifyInvitationCodeResDTO = try await trainerRepository.getVerifyInvitationCode(code: code)
        return result.isVerified
    }
    
    public func connectTrainer(_ info: TraineeConnectInfo) async throws -> ConnectionInfo {
        let resDTO: PostConnectTrainerResDTO = try await traineeRepository.postConnectTrainer(info)
        return ConnectionInfo(
            trainerName: resDTO.trainerName,
            traineeName: resDTO.traineeName,
            trainerProfileImageUrl: resDTO.trainerProfileImageUrl,
            traineeProfileImageUrl: resDTO.traineeProfileImageUrl
        )
    }
}
