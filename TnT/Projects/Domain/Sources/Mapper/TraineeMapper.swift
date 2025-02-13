//
//  TraineeMapper.swift
//  Domain
//
//  Created by 박민서 on 2/14/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

public extension PTInfoResDTO {
    func toEntity() -> WorkoutListItemEntity? {
        guard !self.isEmpty else { return nil }
        return .init(
            id: Int.random(in: 1...10000),
            currentCount: self.session ?? 0,
            startDate: self.lessonStart?.toDate(format: .ISO8601),
            endDate: self.lessonEnd?.toDate(format: .ISO8601),
            trainerProfileImageUrl: self.trainerProfileImage,
            trainerName: self.trainerName ?? "",
            hasRecord: false
        )
    }
}

public extension DietResDTO {
    func toEntity() -> RecordListItemEntity {
        return .init(
            id: self.dietId,
            type: self.dietType.toEntity(),
            date: self.date.toDate(format: .ISO8601),
            title: self.memo,
            hasFeedBack: false,
            imageUrl: self.dietImageUrl
        )
    }
}

public extension DietTypeResDTO {
    func toEntity() -> RecordType? {
        let dietType: DietType? = {
            switch self {
            case .breakfast:
                return .breakfast
            case .lunch:
                return .lunch
            case .dinner:
                return .dinner
            case .snack:
                return .snack
            case .unknown:
                return nil
            }
        }()
        
        guard let dietType else { return nil }
        return .diet(type: dietType)
    }
}
