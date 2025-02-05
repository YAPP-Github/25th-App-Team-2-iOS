//
//  TabInfo.swift
//  Presentation
//
//  Created by 박서연 on 1/24/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import DesignSystem

public enum TrainerTabInfo: String, CaseIterable, Equatable, Sendable {
    case home = "홈"
    case feedback = "피드백"
    case traineeList = "회원목록"
    case mypage = "마이페이지"
    
    public var filledIcn: ImageResource {
        switch self {
        case .home:
            return .icnHomeFilled
        case .feedback:
            return .icnFeedbackFilled
        case .traineeList:
            return .icnListFilled
        case .mypage:
            return .icnMypageFilled
        }
    }
    
    public var emptyIcn: ImageResource {
        switch self {
        case .home:
            return .icnHomeEmpty
        case .feedback:
            return .icnFeedbackEmpty
        case .traineeList:
            return .icnListEmpty
        case .mypage:
            return .icnMypageEmpty
        }
    }
}

public enum TraineeTabInfo: String, CaseIterable, Equatable, Sendable {
    case home = "홈"
    case mypage = "마이페이지"
    
    var filledIcn: ImageResource {
        switch self {
        case .home:
            return .icnHomeFilled
        case .mypage:
            return .icnMypageFilled
        }
    }
    
    var emptyIcn: ImageResource {
        switch self {
        case .home:
            return .icnHomeEmpty
        case .mypage:
            return .icnMypageEmpty
        }
    }
}
