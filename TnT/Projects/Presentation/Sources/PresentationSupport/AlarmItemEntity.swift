//
//  AlarmItemEntity.swift
//  Presentation
//
//  Created by 박민서 on 2/2/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Domain

extension AlarmItemEntity {
    /// 연결 완료, 연결 해제 등
    var alarmTypeText: String {
        switch self.alarmType {
        case .traineeConnected:
            return "트레이니 연결 완료"
        case .traineeDisconnected:
            return "트레이니 연결 해제"
        case .trainerDisconnected:
            return "트레이너 연결 해제"
        }
    }
    
    /// 알람 본문
    var alarmMainText: String {
        switch self.alarmType {
        case .traineeConnected(let name):
            return "\(name) 회원과 연결되었어요"
        case .traineeDisconnected(let name):
            return "\(name) 회원이 연결을 끊었어요"
        case .trainerDisconnected(let name):
            return "\(name) 트레이너가 연결을 끊었어요"
        }
    }
}
