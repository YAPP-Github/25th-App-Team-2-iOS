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
        let height = self.height == 0 ? nil : self.height
        let weight = self.weight == 0 ? nil : self.weight
        return .init(
            traineeName: self.traineeName,
            imageUrl: self.traineeProfileImageUrl,
            age: self.age,
            height: height,
            weight: weight,
            ptGoal: self.ptGoal ?? "",
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

public extension ActiveTraineeInfoResDTO {
    func toEntity() -> TraineeListItemEntity {
        return .init(
            id: self.id,
            name: self.name
        )
    }
}
