//
//  AlarmCheckFeature.swift
//  Presentation
//
//  Created by 박민서 on 2/2/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation
import ComposableArchitecture

import Domain
import DesignSystem

@Reducer
public struct AlarmCheckFeature {
    
    @ObservableState
    public struct State: Equatable {
        // MARK: Data related state
        /// 유저 타입
        var userType: UserType
        /// 알람 정보 목록
        var alarmList: [AlarmItemEntity]
        
        /// `AlarmCheckFeature.State`의 생성자
        /// - Parameters:
        ///   - userType: 유저 타입
        ///   - alarmList: 유저에게 도착한 알람 목록 (기본값: `[]`)
        public init(
            userType: UserType,
            alarmList: [AlarmItemEntity] = []
        ) {
            self.userType = userType
            self.alarmList = alarmList
        }
    }
    
    @Dependency(\.dismiss) private var dismiss
    
    public enum Action: Sendable, ViewAction {
        /// 뷰에서 발생한 액션을 처리합니다.
        case view(View)
        /// 네비게이션 여부 설정
        case setNavigating
        
        @CasePathable
        public enum View: Sendable, BindableAction {
            /// 바인딩 액션 처리
            case binding(BindingAction<State>)
            /// 알람 아이템 탭 되었을 때
            case tapAlarmItem(Int)
            /// 네비게이션 back 버튼 탭 되었을 때
            case tapNavBackButton
        }
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        
        Reduce { state, action in
            switch action {
            case .view(let action):
                switch action {
                case .binding:
                    return .none
                    
                case .tapAlarmItem(let id):
                    print("alarmId: \(id)")
                    return .none
                    
                case .tapNavBackButton:
                    return .run { _ in
                        // TODO: 서버 API 명세 나오면 연결
                        // 현재 모든 알람 확인 표시
                        await self.dismiss()
                    }
                }
            case .setNavigating:
                return .none
            }
        }
    }
}
