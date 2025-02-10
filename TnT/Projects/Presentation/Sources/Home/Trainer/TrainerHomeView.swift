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
        .background(
            VStack {
                Color.common0
                Color.neutral100
            }
        )
        .overlay(alignment: .bottomTrailing) {
            SessionAddButton()
        }
        .navigationBarBackButtonHidden()
        .tPopUp(isPresented: $store.view_isPopUpPresented) {
            PopUpView()
        }
        .onAppear {
            send(.onAppear)
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
                    events: store.events
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
                send(.tapAddSessionButton)
            }
            .padding(.trailing, 22)
            .padding(.bottom, 28)
    }
    
    @ViewBuilder
    private func PopUpView() -> some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text("회원을 연결해 주세요")
                    .typographyStyle(.heading3, with: .neutral900)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                
                Text("연결하지 않을 경우 수업을 추가할 수 없어요\n초대 코드를 복사해 연결해주시겠어요?")
                    .typographyStyle(.body2Medium, with: .neutral500)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                send(.tapPopUpDontShowUntilThreeDaysButton(!store.isHideUntilSelected))
            }) {
                HStack(spacing: 4) {
                    Image(store.isHideUntilSelected ? .icnCheckMarkFilled : .icnCheckMarkEmpty)
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("3일 동안 보지 않기")
                        .typographyStyle(.body2Medium, with: .neutral500)
                    Spacer()
                }
            }
            
            HStack(spacing: 8) {
                TPopUpAlertView.AlertButton(
                    title: "다음에",
                    style: .secondary,
                    action: {
                        send(.tapPopUpNextButton)
                    }
                )
                
                TPopUpAlertView.AlertButton(
                    title: "연결하기",
                    style: .primary,
                    action: {
                        send(.tapPopUpConnectButton)
                    }
                )
            }
        }
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
