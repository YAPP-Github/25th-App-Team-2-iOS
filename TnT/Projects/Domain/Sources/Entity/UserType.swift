//
//  UserType.swift
//  Domain
//
//  Created by 박민서 on 1/17/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

public enum UserType: Sendable {
    case trainer
    case trainee
    
    public var koreanName: String {
        switch self {
        case .trainer:
            return "트레이너"
        case .trainee:
            return "트레이니"
        }
    }
}
