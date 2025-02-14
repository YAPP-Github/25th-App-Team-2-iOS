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
    
    public func getTheFirstInvitationCode() async throws -> GetTheFirstInvitationCodeDTO {
        return try await networkService.request(
            TrainerTargetType.getFirstInvitationCode,
            decodingType: GetTheFirstInvitationCodeDTO.self
        )
    }
    
    public func getReissuanceInvitationCode() async throws -> GetReissuanceInvitationCodeDTO {
        return try await networkService.request(
            TrainerTargetType.putReissuanceInvitationCode,
            decodingType: GetReissuanceInvitationCodeDTO.self
        )
    }
    
    public func getDateSessionList(date: String) async throws -> GetDateSessionListDTO {
        return try await networkService.request(
            TrainerTargetType.getDateLessonList(date: date),
            decodingType: GetDateSessionListDTO.self
        )
    }
    
    public func getMonthlyLessonList(year: Int, month: Int) async throws -> GetMonthlyLessonListResDTO {
        return try await networkService.request(TrainerTargetType.getMonthlyLessonList(year: year, month: month), decodingType: GetMonthlyLessonListResDTO.self)
    }
    
    public func getConnectedTraineeInfo(trainerId: Int64, traineeId: Int64) async throws -> GetConnectedTraineeInfoResponseDTO {
        return try await networkService.request(TrainerTargetType.getConnectedTraineeInfo(trainerId: trainerId, traineeId: traineeId), decodingType: GetConnectedTraineeInfoResponseDTO.self)
    }
    
    public func getActiveTraineesList() async throws -> GetActiveTraineesListResDTO {
        return try await networkService.request(TrainerTargetType.getActiveTraineesList, decodingType: GetActiveTraineesListResDTO.self)
    }
    
    public func postLesson(reqDTO: PostLessonReqDTO) async throws -> PostLessonResDTO {
        return try await networkService.request(TrainerTargetType.postLesson(reqDTO: reqDTO), decodingType: PostLessonResDTO.self)
    }
    
    public func putCompleteLesson(lessonId: Int) async throws -> PutCompleteLessonResDTO {
        return try await networkService.request(TrainerTargetType.putCompleteLesson(lessonId: lessonId), decodingType: PutCompleteLessonResDTO.self)
    }
}
