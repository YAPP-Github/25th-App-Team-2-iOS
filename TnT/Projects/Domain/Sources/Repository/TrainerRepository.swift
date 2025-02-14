//
//  TrainerRepository.swift
//  Domain
//
//  Created by 박민서 on 1/26/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 트레이너 관련 데이터를 관리하는 `TrainerRepository` 프로토콜
/// - 실제 네트워크 요청은 이 인터페이스를 구현한 `TrainerRepositoryImpl`에서 수행됩니다.
public protocol TrainerRepository {
    /// 트레이너 초대 코드 검증 요청
    /// - Parameter code: 초대 코드 (영어 대문자 + 숫자 조합, 최대 8자)
    /// - Returns: 검증 성공 시, 초대 코드 정보가 포함된 응답 DTO (`GetVerifyInvitationCodeResDTO`)
    /// - Throws: 네트워크 오류 또는 유효하지 않은 초대 코드로 인한 서버 오류 발생 가능
    func getVerifyInvitationCode(code: String) async throws -> GetVerifyInvitationCodeResDTO
    
    /// 트레이너 최초 초대 코드 불러오기
    func getTheFirstInvitationCode() async throws -> GetTheFirstInvitationCodeDTO
    
    /// 트레이너 초대 코드 코드 재발급
    func getReissuanceInvitationCode() async throws -> GetReissuanceInvitationCodeDTO
    
    /// 트레이너 캘린더에 특정 날짜의 수업 정보 가져오기
    func getDateSessionList(date: String) async throws -> GetDateSessionListDTO
    
    /// 달력 스케줄 카운트 표시에 필요한 PT 리스트 불러오기
    func getMonthlyLessonList(year: Int, month: Int) async throws -> GetMonthlyLessonListResDTO
    
    /// 연결 완료된 트레이니 정보 불러오기
    func getConnectedTraineeInfo(trainerId: Int, traineeId: Int) async throws -> GetConnectedTraineeInfoResponseDTO
    
    /// 관리 중인 회원 목록 요청
    func getActiveTraineesList() async throws -> GetActiveTraineesListResDTO
    
    /// PT 수업 추가
    func postLesson(reqDTO: PostLessonReqDTO) async throws -> PostLessonResDTO
    
    /// PT 수업 완료 처리
    func putCompleteLesson(lessonId: Int) async throws -> PutCompleteLessonResDTO
}
