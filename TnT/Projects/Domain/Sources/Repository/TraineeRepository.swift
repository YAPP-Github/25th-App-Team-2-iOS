//
//  TraineeRepository.swift
//  Domain
//
//  Created by 박민서 on 1/27/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 트레이니 관련 데이터를 관리하는 `TraineeRepository` 프로토콜
/// - 실제 네트워크 요청은 이 인터페이스를 구현한 `TraineeRepositoryImpl`에서 수행됩니다.
public protocol TraineeRepository {
    /// 트레이너와 트레이니의 연결을 요청합니다.
    /// - Parameter info: 트레이너 연결을 위한 연결 정보 (`PostConnectTrainerReqDTO`)
    /// - Returns: 연결 성공 시, 연결된 트레이너 정보가 포함된 응답 DTO (`PostConnectTrainerResDTO`)
    /// - Throws: 네트워크 오류 또는 잘못된 요청 데이터로 인한 서버 오류 발생 가능
    func postConnectTrainer(_ reqDTO: PostConnectTrainerReqDTO) async throws -> PostConnectTrainerResDTO
    
    /// 회원가입 요청
    /// - Parameters:
    ///   - reqDTO: 식단 등록 요청에 필요한 데이터
    ///   - imgData: 사용자가 업로드한 식단 이미지 (옵션)
    /// - Returns: 등록 성공 시, 응답 DTO (empty) (`PostTraineeDietRecordResDTO`)
    /// - Throws: 네트워크 오류 또는 서버에서 반환한 오류를 발생시킬 수 있음
    func postTraineeDietRecord(_ reqDTO: PostTraineeDietRecordReqDTO, imgData: Data?) async throws -> PostTraineeDietRecordResDTO
    
    /// 캘린더 수업, 기록 존재하는 날짜 조회 요청
    /// - Parameters:
    ///   - startDate: 조회 시작 날짜
    ///   - endDate: 조회 종료 날짜
    /// - Returns: 등록 성공 시, 응답 DTO (`GetActiveDateListResDTO`)
    /// - Throws: 네트워크 오류 또는 서버에서 반환한 오류를 발생시킬 수 있음
    func getActiveDateList(startDate: String, endDate: String) async throws -> GetActiveDateListResDTO
    
    /// 특정 날짜 수업, 기록 조회
    /// - Parameters:
    ///   - date: 조회 특정 날짜
    /// - Returns: 등록 성공 시, 응답 DTO (`GetActiveDateDetailResDTO`)
    /// - Throws: 네트워크 오류 또는 서버에서 반환한 오류를 발생시킬 수 있음
    func getActiveDateDetail(date: String) async throws -> GetActiveDateDetailResDTO
    
    /// 특정 식단 조회 요청
    /// - Parameters:
    ///   - dietId: 조회 특정 식단 ID
    /// - Returns: 등록 성공 시, 응답 DTO (`GetDietRecordDetailResDTO`)
    /// - Throws: 네트워크 오류 또는 서버에서 반환한 오류를 발생시킬 수 있음
    func getDietRecordDetail(dietId: Int) async throws -> GetDietRecordDetailResDTO
}
