//
//  TraineeHomeFeature.swift
//  Presentation
//
//  Created by 박민서 on 2/2/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation
import ComposableArchitecture

import Domain

@Reducer
public struct TraineeHomeFeature {
    
    @ObservableState
    public struct State: Equatable {
        // MARK: Data related state
        /// 선택된 날짜
        var selectedDate: Date
        /// 캘린더 이벤트
        var events: [Date: Int]
        /// 수업 정보
        var sessionInfo: WorkoutListItemEntity?
        /// 기록 정보 목록
        var records: [RecordListItemEntity]
        
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
            return TDateFormatUtility.formatter(for: .MM월_dd일_EEEE).string(from: selectedDate)
        }
        /// 선택 바텀 시트 표시
        var view_isBottomSheetPresented: Bool
        /// 팝업 표시
        // TODO: 3일 동안 보지 않기 로직 작성 때 추가
        var view_isPopUpPresented: Bool
        
        public init(
            selectedDate: Date = .now,
            events: [Date: Int] = [:],
            sessionInfo: WorkoutListItemEntity? = nil,
            records: [RecordListItemEntity] = [],
            view_currentPage: Date = .now,
            view_isBottomSheetPresented: Bool = false,
            view_isPopUpPresented: Bool = false
        ) {
            self.selectedDate = selectedDate
            self.events = events
            self.sessionInfo = sessionInfo
            self.records = records
            self.view_currentPage = view_currentPage
            self.view_isBottomSheetPresented = view_isBottomSheetPresented
            self.view_isPopUpPresented = view_isPopUpPresented
        }
    }
    
    @Dependency(\.traineeUseCase) private var traineeUseCase: TraineeUseCase
    
    public enum Action: Equatable, Sendable, ViewAction {
        /// 뷰에서 발생한 액션을 처리합니다.
        case view(View)
        /// 네비게이션 여부 설정
        case setNavigating(RoutingScreen)
        
        @CasePathable
        public enum View: Equatable, Sendable, BindableAction {
            /// 바인딩할 액션을 처리
            case binding(BindingAction<State>)
            /// 우측 상단 알림 페이지 보기 버튼 탭
            case tapAlarmPageButton
            /// 상단 수업 기록 보기 버튼 탭
            case tapShowSessionRecordButton(id: Int)
            /// 기록 목록 피드백 보기 버튼 탭
            case tapShowRecordFeedbackButton(id: Int)
            /// 우측 하단 기록 추가 버튼 탭
            case tapAddRecordButton
            /// 개인 운동 기록 추가 버튼 탭
            case tapAddWorkoutRecordButton
            /// 식단 기록 추가 버튼 탭
            case tapAddMealRecordButton
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
                    return .none
                case .binding:
                    return .none
                case .tapAlarmPageButton:
                    return .send(.setNavigating(.alarmPage))
                case .tapShowSessionRecordButton(let id):
                    // TODO: 네비게이션 연결 시 추가
                    print("tapShowSessionRecordButton \(id)")
                    return .none
                case .tapShowRecordFeedbackButton(let id):
                    // TODO: 네비게이션 연결 시 추가
                    print("tapShowRecordFeedbackButton \(id)")
                    return .none
                case .tapAddRecordButton:
                    state.view_isBottomSheetPresented = true
                    return .none
                case .tapAddWorkoutRecordButton:
                    // TODO: 네비게이션 연결 시 추가
                    print("tapAddWorkoutRecordButton")
                    return .none
                case .tapAddMealRecordButton:
                    // TODO: 네비게이션 연결 시 추가
                    print("tapAddMealRecordButton")
                    return .none
                }
            case .setNavigating:
                return .none
            }
        }
    }
}

extension TraineeHomeFeature {
    public enum RoutingScreen: Sendable {
        /// 알림 페이지
        case alarmPage
        /// 수업 기록 상세 페이지
        case sessionRecordPage
        /// 기록 피드백 페이지
        case recordFeedbackPage
        /// 운동 기록 추가 페이지
        case addWorkoutRecordPage
        /// 식단 기록 추가 페이지
        case addMealRecordPage
    }
}
