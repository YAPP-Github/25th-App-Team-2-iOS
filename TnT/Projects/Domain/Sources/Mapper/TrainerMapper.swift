//
//  TrainerMapper.swift
//  Domain
//
//  Created by 박민서 on 2/11/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

public extension ConnectTraineeInfoDTO {
    func toEntity() -> ConnectedTraineeProfileEntity {
        return .init(
            traineeName: self.traineeName,
            imageUrl: self.traineeProfileImageUrl,
            age: self.age,
            height: self.height,
            weight: self.weight,
            ptGoal: self.ptGoal,
            cautionNote: self.cautionNote
        )
    }
}

public extension GetConnectedTraineeInfoResponseDTO {
    func toEntity() -> ConnectionInfoEntity {
        return .init(
            trainerName: self.trainer.trainerName,
            traineeName: self.trainee.traineeName,
            trainerProfileImageUrl: self.trainer.trainerProfileImageUrl,
            traineeProfileImageUrl: self.trainee.traineeProfileImageUrl
        )
    }
}
