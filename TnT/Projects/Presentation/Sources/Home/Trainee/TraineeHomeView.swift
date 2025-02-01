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
public struct TraineeHomeView: View {
    
    // MARK: 임시 State
    @State var ispresented: Bool = false
    @State var selectedDate: Date = Date()
    @State var currentPage: Date = Date()
    @State var events: [Date: Int] = [:]
    @State var todaysSessionInfo: WorkoutListItemEntity? = .init(currentCount: 8, startDate: .now, endDate: .now, trainerProfileImageUrl: nil, trainerName: "김민수", hasRecord: true)
    @State var records: [RecordListItemEntity] = [
        .init(type: .meal(type: .lunch), date: .now, title: "자고싶다", hasFeedBack: true, imageUrl: nil),
        .init(type: .meal(type: .dinner), date: .now, title: "자고싶다", hasFeedBack: false, imageUrl: "https://images.genius.com/8e0b15e4847f8e59db7dfda22b4db4ec.1000x1000x1.png"),
        .init(type: .meal(type: .morning), date: .now, title: "자고싶다", hasFeedBack: true, imageUrl: nil)
    ]
    @State var toggleMode: Bool = true
    
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                CalendarSection()
                
                RecordListSection()
                    .background(Color.neutral100)
                
                Spacer()
            }
        }
        .overlay(alignment: .bottomTrailing) {
            Button(action: {
                // TODO: STORE
                ispresented = true
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
        .sheet(isPresented: $ispresented) {
            TraineeRecordStartView(itemContents: [
                ("🏋🏻‍♀️", "개인 운동", {
                    // TODO: Store 연결
                    print("pop")
                }),
                ("🥗", "식단", {
                    // TODO: Store 연결
                    print("pop")
                })
            ])
            .autoSizingBottomSheet()
        }
    }
    
    // MARK: - Sections
    @ViewBuilder
    private func CalendarSection() -> some View {
        VStack(spacing: 16) {
            TCalendarHeader(
                currentPage: $currentPage,
                formatter: { TDateFormatUtility.formatter(for: .yyyy년_MM월).string(from: $0) },
                rightView: {
                    Button(action: {
                        // TODO: Store 연결
                        print("pop")
                        toggleMode.toggle()
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
                    selectedDate: $selectedDate,
                    currentPage: $currentPage,
                    events: events,
                    isWeekMode: toggleMode
                )
                .padding(.horizontal, 20)
                
                if let todaysSessionInfo {
                    TWorkoutCard(
                        chipUIInfo: RecordType.session(count: todaysSessionInfo.currentCount).chipInfo,
                        timeText: "\(TDateFormatUtility.formatter(for: .a_HHmm).string(from: todaysSessionInfo.startDate)) ~ \(TDateFormatUtility.formatter(for: .a_HHmm).string(from: todaysSessionInfo.endDate))",
                        title: "\(todaysSessionInfo.trainerName) 트레이너",
                        imgURL: .init(string: todaysSessionInfo.trainerProfileImageUrl ?? ""),
                        hasRecord: todaysSessionInfo.hasRecord,
                        footerTapAction: {
                            // TODO: STORe
                            print("얍ㅂ삐")
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
            Text(TDateFormatUtility.formatter(for: .MM월_dd일_EEEE).string(from: selectedDate))
                .typographyStyle(.heading3, with: .neutral800)
                .padding(20)
            
            VStack(spacing: 12) {
                ForEach(records.indices, id: \.self) { index in
                    let item = records[index]
                    TRecordCard(
                        chipUIInfo: item.type.chipInfo,
                        timeText: TDateFormatUtility.formatter(for: .a_HHmm).string(from: item.date),
                        title: "자고 싶어요 진짜로 ㄴㅇㅁㄹㅁㄴㅇ래ㅣㅑㅕㅗㅁㅈㄷ;ㅐㅓㅑㅗㅁㅈㄷ래ㅑ;ㅗㅓㅁㄷㄹㅈ;ㅐㅗㅕㅑㄷㄹㅁㅈ",
                        imgURL: URL(string: item.imageUrl ?? ""),
                        hasFeedback: item.hasFeedBack,
                        footerTapAction: {
                            // TODO: STORE
                            print("pop\(index)")
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
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
                Text("추가 버튼을 눌러 식사와 운동을 기록해보세요")
                    .typographyStyle(.body2Bold, with: .neutral600)
                    .frame(maxWidth: .infinity)
                
                Text("추가 버튼을 눌러 식사와 운동을 기록해보세요")
                    .typographyStyle(.label1Medium, with: .neutral400)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}
