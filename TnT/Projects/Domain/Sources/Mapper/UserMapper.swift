//
//  UserMapper.swift
//  Domain
//
//  Created by 박민서 on 2/12/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

public extension GetMyPageInfoResDTO {
    func toEntity() -> TraineeMyPageEntity {
        return .init(
            isConnected: self.trainee?.isConnected ?? false,
            name: self.name,
            profileImageUrl: self.profileImageUrl,
            socialType: self.socialType
        )
    }
    
    func toEntity() -> TrainerMyPageEntity {
        return .init(
            name: self.name,
            profileImageUrl: self.profileImageUrl,
            socialType: self.socialType,
            activeTraineeCount: self.trainer?.activeTraineeCount,
            totalTraineeCount: self.trainer?.totalTraineeCount
        )
    }
}
