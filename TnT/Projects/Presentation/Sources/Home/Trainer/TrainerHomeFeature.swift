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
        /// 3일 동안 보지 않기 시작 날짜
        @Shared(.appStorage(AppStorage.hideHomePopupUntil)) var hidePopupUntil: Date?
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
        /// 3일 동안 보지 않기 선택되었는지 여부
        var isHideUntilSelected: Bool
        /// 트레이니 연결 여부
        var isConnected: Bool
        
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
        /// 팝업 표시 여부
        var view_isPopUpPresented: Bool
        
        public init(
            selectedDate: Date = .now,
            events: [Date: Int] = [:],
            sessionCount: Int = 0,
            sessionInfo: WorkoutListItemEntity? = nil,
            records: [RecordListItemEntity] = [],
            isHideUntilSelected: Bool = false,
            isConnected: Bool = false,
            view_currentPage: Date = .now,
            tappedsessionInfo: GetDateSessionListEntity? = nil,
            view_isPopUpPresented: Bool = false
        ) {
            self.selectedDate = selectedDate
            self.events = events
            self.sessionCount = sessionCount
            self.sessionInfo = sessionInfo
            self.records = records
            self.isHideUntilSelected = isHideUntilSelected
            self.isConnected = isConnected
            self.view_currentPage = view_currentPage
            self.tappedsessionInfo = tappedsessionInfo
            self.view_isPopUpPresented = view_isPopUpPresented
        }
    }
    
    @Dependency(\.traineeUseCase) private var traineeUseCase: TraineeUseCase
    @Dependency(\.trainerRepoUseCase) private var trainerRepoUseCase: TrainerRepository
    
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
            /// 연결 권장 팝업 - 다음에 버튼 탭
            case tapPopUpNextButton
            /// 연결 권장 팝업 - 3일 동안 보지 않기 버튼 탭
            case tapPopUpDontShowUntilThreeDaysButton(Bool)
            /// 연결 권장 팝업 - 연결하기 버튼 탭
            case tapPopUpConnectButton
            /// 화면이 표시될 때
            case onAppear
            /// events 타입에 맞춰서 달력 스케줄 캐수 표시 데이터 계산
            case fetchMonthlyLessons(year: Int, month: Int)
            /// 달력 스케줄 캐수 표시 데이터 업데이트
            case updateEvents([Date: Int])
            /// 특정 날짜 탭
            case calendarDateTap
            /// 탭한 일자 api 형태에 맞춰 변환하기(yyyy-mm-dd)
            case settingSessionList(sessions: GetDateSessionListEntity)
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
                    print("state.events[state.selectedDate] \(state.events[state.selectedDate])")
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
                    
                case .tapPopUpNextButton:
                    if state.isHideUntilSelected {
                        state.$hidePopupUntil.withLock {
                            $0 = Calendar.current.date(byAdding: .day, value: 3, to: Date())
                        }
                    }
                    state.view_isPopUpPresented = false
                    return .none
                    
                case .tapPopUpDontShowUntilThreeDaysButton(let isHidden):
                    state.isHideUntilSelected = isHidden
                    return .none
                    
                case .tapPopUpConnectButton:
                    if state.isHideUntilSelected {
                        state.$hidePopupUntil.withLock {
                            $0 = Calendar.current.date(byAdding: .day, value: 3, to: Date())
                        }
                    }
                    state.view_isPopUpPresented = false
                    return .send(.setNavigating(.trainerMakeInvitationCodePage))
                    
                case .onAppear:
                    let year: Int = Calendar.current.component(.year, from: state.selectedDate)
                    let month: Int = Calendar.current.component(.month, from: state.selectedDate)
                    
                    if let hideUntil = state.hidePopupUntil, hideUntil > Date() {
                        state.view_isPopUpPresented = false
                    } else {
                        state.view_isPopUpPresented = true
                    }
                    
                    return .send(.view(.fetchMonthlyLessons(year: year, month: month)))
                    
                case .fetchMonthlyLessons(year: let year, month: let month):
                    return .run { send in
                        do {
                            let temp: GetMonthlyLessonListResDTO = try await trainerRepoUseCase.getMonthlyLessonList(
                                year: year,
                                month: month
                            )
                            
                            let dateFormatter: DateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            
                            var events: [Date: Int] = [:]
                            for lesson in temp.calendarPtLessonCounts {
                                if let date = dateFormatter.date(from: lesson.date) {
                                    events[date] = lesson.count
                                } else {
                                    print("Invalid date format: \(lesson.date)")
                                }
                            }
                            await send(.view(.updateEvents(events)))
                        } catch {
                            print("리스트 Fetching Error: \(error)")
                        }
                    }
                case .updateEvents(let events):
                    state.events = events
                    return .none
                    
                case .calendarDateTap:
                    let formattedDate = TDateFormatUtility.formatter(for: .yyyyMMdd).string(from: state.selectedDate)
                    
                    return .run { send in
                        do {
                            let sessionList: GetDateSessionListEntity = try await trainerRepoUseCase.getDateSessionList(date: formattedDate).toEntity()
                            await send(.view(.settingSessionList(sessions: sessionList)))
                        } catch {
                            print("error \(error.localizedDescription)")
                        }
                    }
                    
                case .settingSessionList(let list):
                    state.tappedsessionInfo = list
                    return .none
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
        /// 초대 코드 발급페이지
        case trainerMakeInvitationCodePage
    }
}
