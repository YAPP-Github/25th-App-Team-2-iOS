//
//  TrainerHomeFeature.swift
//  Presentation
//
//  Created by 박서연 on 2/5/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import Domain
import DesignSystem

@Reducer
public struct TrainerHomeFeature {
    
    @ObservableState
    public struct State: Equatable {
        // MARK: Data related state
        /// 선택된 날짜
        var selectedDate: Date
        /// 캘린더 이벤트
        var events: [Date: Int]
        /// 수업 갯수 정보
        var sessionCount: Int
        /// 수업 정보
        var sessionInfo: WorkoutListItemEntity?
        /// 기록 정보 목록
        var records: [RecordListItemEntity]
        /// 특정 날짜의 수업 정보
        var tappedsessionInfo: GetDateSessionListEntity?
        
        // MARK: UI related state
        /// 캘린더 표시 페이지
        var view_currentPage: Date
        /// 수업 카드 시간 표시
        var view_sessionCardTimeString: String {
            guard let sessionInfo else { return "" }
            return "\(TDateFormatUtility.formatter(for: .a_HHmm).string(from: sessionInfo.startDate)) ~ \(TDateFormatUtility.formatter(for: .a_HHmm).string(from: sessionInfo.endDate))"
        }
        /// 기록 제목 표시
        var view_recordTitleString: String {
            return TDateFormatUtility.formatter(for: .M월_d일_EEEE).string(from: selectedDate)
        }
        /// 팝업 표시
        // TODO: 3일 동안 보지 않기 로직 작성 때 추가
        var view_isPopUpPresented: Bool
        
        public init(
            selectedDate: Date = .now,
            events: [Date: Int] = [:],
            sessionCount: Int = 0,
            sessionInfo: WorkoutListItemEntity? = nil,
            records: [RecordListItemEntity] = [],
            view_currentPage: Date = .now,
            tappedsessionInfo: GetDateSessionListEntity? = nil,
            view_isPopUpPresented: Bool = false
        ) {
            self.selectedDate = selectedDate
            self.events = events
            self.sessionCount = sessionCount
            self.sessionInfo = sessionInfo
            self.records = records
            self.view_currentPage = view_currentPage
            self.tappedsessionInfo = tappedsessionInfo
            self.view_isPopUpPresented = view_isPopUpPresented
        }
    }
    
    @Dependency(\.traineeUseCase) private var traineeUseCase: TraineeUseCase
    
    public enum Action: Sendable, ViewAction {
        /// 뷰에서 발생한 액션을 처리합니다.
        case view(View)
        /// 네비게이션 여부 설정
        case setNavigating(RoutingScreen)
        
        @CasePathable
        public enum View: Sendable, BindableAction {
            /// 바인딩할 액션을 처리
            case binding(BindingAction<State>)
            /// 우측 상단 알림 페이지 보기 버튼 탭
            case tapAlarmPageButton
            /// 수업 완료 버튼 탭
            case tapSessionCompleted(id: String)
            /// 수업 추가 버튼 탭
            case tapAddSessionButton
        }
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        
        Reduce { state, action in
            switch action {
                
            case .view(let action):
                switch action {
                case .binding(\.selectedDate):
                    print(state.events[state.selectedDate])
                    return .none
                case .binding:
                    return .none
                case .tapAlarmPageButton:
                    return .send(.setNavigating(.alarmPage))
                case .tapSessionCompleted(let id):
                    // TODO: 네비게이션 연결 시 추가
                    print("tapSessionCompleted otLessionID \(id)")
                    return .none
                case .tapAddSessionButton:
                    return .send(.setNavigating(.addPTSessionPage))
                }
            case .setNavigating:
                return .none
            }
        }
    }
}

extension TrainerHomeFeature {
    public enum RoutingScreen: Sendable {
        /// 알림 페이지
        case alarmPage
        /// PT 일정 추가페이지
        case addPTSessionPage
    }
}
