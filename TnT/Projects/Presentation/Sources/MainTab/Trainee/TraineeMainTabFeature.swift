//
//  TraineeMainTabNavigationFeature.swift
//  Presentation
//
//  Created by 박민서 on 2/4/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

@Reducer
public struct TraineeMainTabFeature {
    @ObservableState
    public enum State: Equatable {
        case home(TraineeHomeFeature.State)
        case myPage(TraineeMyPageFeature.State)
        
        public init() {
            self = .home(TraineeHomeFeature.State())
        }
    }

    public enum Action: Sendable, ViewAction {
        /// 뷰에서 일어나는 액션을 처리합니다.
        case view(View)
        /// 하위 화면에서 일어나는 액션을 처리합니다
        case subFeature(SubFeatureAction)
        /// 화면 네비게이션 설정
        case setNavigating(RoutingScreen)
        
        @CasePathable
        public enum View: Sendable {
            case selectTab(Tab)
        }
        
        @CasePathable
        public enum SubFeatureAction: Sendable {
            /// 홈 화면에서 발생하는 액션 처리
            case homeAction(TraineeHomeFeature.Action)
            /// 마이페이지 화면에서 발생하는 액션 처리
            case myPageAction(TraineeMyPageFeature.Action)
        }
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(view):
                switch view {
                case .selectTab(let tab):
                    switch tab {
                    case .home:
                        state = .home(.init())
                        return .none
                    case .myPage:
                        state = .myPage(.init())
                        return .none
                    }
                }
                
            case .subFeature(let internalAction):
                switch internalAction {
                case .homeAction(.setNavigating(let screen)):
                    return .send(.setNavigating(.traineeHome(screen)))
                case .myPageAction(.setNavigating(let screen)):
                    return .send(.setNavigating(.traineeMyPage(screen)))
                default:
                    return .none
                }
                
            case .setNavigating(let screen):
                return .none
            }
        }
        .ifCaseLet(\.home, action: \.subFeature.homeAction) {
            TraineeHomeFeature()
        }
        .ifCaseLet(\.myPage, action: \.subFeature.myPageAction) {
            TraineeMyPageFeature()
        }
    }
}

extension TraineeMainTabFeature {
    public enum Tab: Equatable, Sendable {
        case home
        case myPage
    }
    
    /// 하위 화면에서 파생되는 라우팅을 전달합니다
    public enum RoutingScreen: Sendable {
        /// 트레이니 홈
        case traineeHome(TraineeHomeFeature.RoutingScreen)
        /// 트레이니 마이페이지
        case traineeMyPage(TraineeMyPageFeature.RoutingScreen)
    }
}
