//
//  TraineeHomeView.swift
//  Presentation
//
//  Created by 박민서 on 2/2/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import Domain
import DesignSystem

/// 트레이니의 메인 홈 뷰입니다
@ViewAction(for: TraineeHomeFeature.self)
public struct TraineeHomeView: View {
    
    @Bindable public var store: StoreOf<TraineeHomeFeature>
    
    public init(store: StoreOf<TraineeHomeFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                CalendarSection()
                    .background(Color.common0)
                
                RecordListSection()
                    .frame(maxWidth: .infinity)
                    .background(Color.neutral100)
                    
                Spacer()
            }
        }
        .background(
            VStack {
                Color.common0
                Color.neutral100
            }
        )
        .overlay(alignment: .bottomTrailing) {
            Button(action: {
                send(.tapAddRecordButton)
            }, label: {
                Image(.icnPlus)
                    .renderingMode(.template)
                    .resizable()
                    .tint(Color.common0)
                    .frame(width: 24, height: 24)
                    .padding(16)
                    .background(Color.neutral900)
                    .clipShape(.rect(cornerRadius: 16))
            })
            .padding(.bottom, 20)
            .padding(.trailing, 12)
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $store.view_isBottomSheetPresented) {
            TraineeRecordStartView(itemContents: [
                ("🏋🏻‍♀️", "개인 운동", { send(.tapAddWorkoutRecordButton) }),
                ("🥗", "식단", { send(.tapAddMealRecordButton) })
            ])
            .autoSizingBottomSheet()
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
            
            // Calendar + 금일 수업 카드
            VStack(spacing: 12) {
                TCalendarView(
                    selectedDate: $store.selectedDate,
                    currentPage: $store.view_currentPage,
                    events: store.events,
                    mode: .week
                )
                .padding(.horizontal, 20)
                
                if let sessionInfo = store.sessionInfo {
                    TWorkoutCard(
                        chipUIInfo: RecordType.session(count: sessionInfo.currentCount).chipInfo,
                        timeText: store.view_sessionCardTimeString,
                        title: "\(sessionInfo.trainerName) 트레이너",
                        imgURL: .init(string: sessionInfo.trainerProfileImageUrl ?? ""),
                        hasRecord: sessionInfo.hasRecord,
                        footerTapAction: {
                            send(.tapShowSessionRecordButton(id: sessionInfo.id))
                        }
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                } else {
                    SessionEmptyView()
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                }
            }
            
        }
        .padding(.vertical, 12)
        
    }
    
    @ViewBuilder
    private func RecordListSection() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(store.view_recordTitleString)
                    .typographyStyle(.heading3, with: .neutral800)
                    .padding(20)
                Spacer()
            }
            
            VStack(spacing: 12) {
                if !store.records.isEmpty {
                    ForEach(store.records, id: \.id) { item in
                        TRecordCard(
                            chipUIInfo: item.type.chipInfo,
                            timeText: TDateFormatUtility.formatter(for: .a_HHmm).string(from: item.date),
                            title: item.title,
                            imgURL: URL(string: item.imageUrl ?? ""),
                            hasFeedback: item.hasFeedBack,
                            footerTapAction: {
                                send(.tapShowRecordFeedbackButton(id: item.id))
                            }
                        )
                    }
                } else {
                    RecordEmptyView()
                        .padding(.top, 80)
                        .padding(.bottom, 100)
                }
            }
            .padding(.horizontal, 16)
            
            Spacer()
        }
    }
}

private extension TraineeHomeView {
    /// 예정된 수업이 없어요
    struct SessionEmptyView: View {
        var body: some View {
            Text("예정된 수업이 없어요")
                .typographyStyle(.label1Medium, with: .neutral400)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
        }
    }
    
    /// 아직 기록이 없어요
    struct RecordEmptyView: View {
        var body: some View {
            VStack(spacing: 4) {
                Text("아직 기록이 없어요")
                    .typographyStyle(.body2Bold, with: .neutral600)
                    .frame(maxWidth: .infinity)
                
                Text("추가 버튼을 눌러 식사와 운동을 기록해보세요")
                    .typographyStyle(.label1Medium, with: .neutral400)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}
