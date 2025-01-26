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
    /// - Parameter info: 트레이너 연결을 위한 연결 정보 (`TraineeConnectInfo`)
    /// - Returns: 연결 성공 시, 연결된 트레이너 정보가 포함된 응답 DTO (`PostConnectTrainerResDTO`)
    /// - Throws: 네트워크 오류 또는 잘못된 요청 데이터로 인한 서버 오류 발생 가능
    func postConnectTrainer(_ info: TraineeConnectInfo) async throws -> PostConnectTrainerResDTO
}
