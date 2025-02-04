//
//  TrainerHomeView.swift
//  Presentation
//
//  Created by 박서연 on 2/4/25.
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
        /// 선택 바텀 시트 표시
        var view_isBottomSheetPresented: Bool
        
        public init(
            selectedDate: Date = .now,
            events: [Date: Int] = [:],
            sessionCount: Int = 0,
            sessionInfo: WorkoutListItemEntity? = nil,
            records: [RecordListItemEntity] = [],
            view_currentPage: Date = .now,
            view_isBottomSheetPresented: Bool = false,
            tappedsessionInfo: GetDateSessionListEntity? = nil
        ) {
            self.selectedDate = selectedDate
            self.events = events
            self.sessionCount = sessionCount
            self.sessionInfo = sessionInfo
            self.records = records
            self.view_currentPage = view_currentPage
            self.view_isBottomSheetPresented = view_isBottomSheetPresented
            self.tappedsessionInfo = tappedsessionInfo
        }
    }
    
    @Dependency(\.traineeUseCase) private var traineeUseCase: TraineeUseCase
    
    public enum Action: Sendable, ViewAction {
        /// 뷰에서 발생한 액션을 처리합니다.
        case view(View)
        /// 네비게이션 여부 설정
        case setNavigating
        
        @CasePathable
        public enum View: Sendable, BindableAction {
            /// 바인딩할 액션을 처리
            case binding(BindingAction<State>)
            /// 우측 상단 알림 페이지 보기 버튼 탭
            case tapAlarmPageButton
            /// 수업 완료 버튼 탭
            case tapSessionCompleted(id: String)
            /// 식단 기록 추가 버튼 탭
            case tapAddSessionRecordButton
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
                    // TODO: 네비게이션 연결 시 추가
                    print("tapAlarmPageButton")
                    return .none
                case .tapSessionCompleted(let id):
                    // TODO: 네비게이션 연결 시 추가
                    print("tapSessionCompleted otLessionID \(id)")
                    return .none
                case .tapAddSessionRecordButton:
                    // TODO: 네비게이션 연결 시 추가
                    print("tapAddSessionRecordButton")
                    return .none
                }
            case .setNavigating:
                return .none
            }
        }
    }
}

@ViewAction(for: TrainerHomeFeature.self)
public struct TrainerHomeView: View {
    
    @Bindable public var store: StoreOf<TrainerHomeFeature>
    
    public init(store: StoreOf<TrainerHomeFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                CalendarSection()
                    .background(Color.common0)
                RecordTitle()
                RecordList()
            }
            .background(Color.neutral100)
        }
        .overlay(alignment: .bottomTrailing) {
            SessionAddButton()
        }
    }
    
    // MARK: - Sections
    @ViewBuilder
    private func CalendarSection() -> some View {
        VStack(spacing: 16) {
            TCalendarHeader(
                currentPage: $store.view_currentPage,
                formatter: { TDateFormatUtility.formatter(for: .yyyy년_MM월).string(from: $0) },
                rightView: {
                    Button(action: {
                        send(.tapAlarmPageButton)
                    }, label: {
                        Image(.icnAlarm)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    })
                }
            )
            
            // Calendar
            VStack(spacing: 12) {
                TCalendarView(
                    selectedDate: $store.selectedDate,
                    currentPage: $store.view_currentPage,
                    events: store.events,
                    isWeekMode: false
                )
                .padding(.horizontal, 20)
            }
        }
        .padding(.vertical, 12)
        
    }
    
    /// 수업 리스트 상단 타이틀
    @ViewBuilder
    private func RecordTitle() -> some View {
        HStack {
            Text(store.view_recordTitleString)
                .typographyStyle(.heading3, with: .neutral800)
                .padding(.vertical, 20)
            
            Spacer()
            
            HStack(spacing: 0) {
                Text("🧨")
                    .typographyStyle(.label1Medium)
                Text("\(store.sessionCount)")
                    .typographyStyle(.label2Bold, with: Color.red500)
                Text("개의 수업이 있어요")
                    .typographyStyle(.label2Medium, with: Color.neutral800)
            }
        }
        .padding(.horizontal, 20)
        .background(Color.neutral100)
        
    }
    
    /// 수업 리스트
    @ViewBuilder
    private func RecordList() -> some View {
        VStack {
            if let record = store.tappedsessionInfo {
                ForEach(record.lessons, id: \.id) { record in
                    SessionCellView(session: record) {
                        send(.tapSessionCompleted(id: record.ptLessonId))
                    }
                }
            } else {
                RecordEmptyView()
            }
        }
        .padding(.horizontal, 20)
    }
    
    /// 수업 추가 버튼
    @ViewBuilder
    private func SessionAddButton() -> some View {
        Capsule()
            .fill(Color.neutral900)
            .frame(width: 126, height: 58)
            .overlay {
                HStack(spacing: 4) {
                    Image(.icnPlusEmpty)
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("수업추가")
                        .typographyStyle(.body1Medium, with: .neutral50)
                }
            }
            .onTapGesture {
                send(.tapAddSessionRecordButton)
            }
            .padding(.trailing, 22)
            .padding(.bottom, 28)
    }
}

extension TrainerHomeView {
    
    /// 아직 등록된 수업이 없어요
    struct RecordEmptyView: View {
        var body: some View {
            VStack(spacing: 4) {
                Text("아직 등록된 수업이 없어요")
                    .typographyStyle(.body2Bold, with: .neutral600)
                    .frame(maxWidth: .infinity)
                Text("추가 버튼을 눌러 PT 수업 일정을 추가해 보세요")
                    .typographyStyle(.label1Medium, with: .neutral400)
                    .frame(maxWidth: .infinity)
            }
            .padding(.top, 80)
            .padding(.bottom, 100)
        }
    }
    
    /// 수업 목록리스트의 셀
    struct SessionCellView: View {
        var session: SessonEntity
        var onTapComplete: () -> Void
        
        var body: some View {
            HStack(spacing: 20) {
                Image(session.isCompleted ? .icnCheckBoxSelected : .icnCheckBoxUnselected)
                    .resizable()
                    .frame(width: 32, height: 32)
                    .onTapGesture {
                        /// 수업 완료 버튼 탭
                        onTapComplete()
                    }
                
                VStack(spacing: 12) {
                    HStack(spacing: 4) {
                        TChip(leadingEmoji: "💪", title: "\(session.session)회차 수업", style: .blue)
                        Spacer()
                        Image(.icnClock)
                        Text("\(session.startTime) ~ \(session.endTime)")
                    }
                    Text(session.traineeName)
                    
                    if session.isCompleted {
                        Button {
                            //
                        } label: {
                            HStack(spacing: 4) {
                                Image(.icnWriteWhite)
                                Text("PT 수업 기록 남기기")
                                    .typographyStyle(.label2Medium, with: .neutral400)
                            }
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
                .padding(.init(top: 16, leading: 12, bottom: 16, trailing: 12))
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
        }
    }
}
