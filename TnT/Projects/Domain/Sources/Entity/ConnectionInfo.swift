//
//  ConnectionInfo.swift
//  Domain
//
//  Created by 박민서 on 1/27/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 트레이너와 트레이니가 연결된 정보
public struct ConnectionInfo {
    /// 트레이너 이름
    public let trainerName: String
    /// 트레이니 이름
    public let traineeName: String
    /// 트레이너 프로필 이미지 URL
    public let trainerProfileImageUrl: URL?
    /// 트레이니 프로필 이미지 URL
    public let traineeProfileImageUrl: URL?
    
    public init(trainerName: String, traineeName: String, trainerProfileImageUrl: String, traineeProfileImageUrl: String) {
        self.trainerName = trainerName
        self.traineeName = traineeName
        self.trainerProfileImageUrl = URL(string: trainerProfileImageUrl)
        self.traineeProfileImageUrl = URL(string: traineeProfileImageUrl)
    }
}
