//
//  TCalendarView.swift
//  DesignSystem
//
//  Created by 박민서 on 2/2/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// 앱 전반적으로 사용되는 캘린더입니다.
/// 주간/월간 표시를 포함합니다.
public struct TCalendarView: View {

    /// 선택한 날짜
    @Binding var selectedDate: Date
    /// 현재 페이지
    @Binding var currentPage: Date
    /// 업데이트 플래그
    @State private var forceUpdate: UUID = UUID()
    /// 캘린더 높이
    @State private var calendarHeight: CGFloat = TCalendarType.month.calendarHeight
    /// 주간/월간/컴팩트 모드인지 표시
    private var mode: TCalendarType = .month
    /// 캘린더 표시 이벤트 딕셔너리
    private var events: [Date: Int]
    
    public init(
        selectedDate: Binding<Date>,
        currentPage: Binding<Date>,
        forceUpdate: UUID = UUID(),
        events: [Date: Int] = [:],
        mode: TCalendarType = .month
    ) {
        self._selectedDate = selectedDate
        self._currentPage = currentPage
        self.events = events
        self.forceUpdate = forceUpdate
        self.mode = mode
    }

    public var body: some View {
        GeometryReader { proxy in
            TCalendarRepresentable(
                selectedDate: $selectedDate,
                currentPage: $currentPage,
                calendarHeight: $calendarHeight,
                mode: mode,
                events: events
            )
            .frame(width: proxy.size.width, height: TCalendarType.month.calendarHeight)
            .id(forceUpdate)
            .onChange(of: events) {
                forceUpdate = UUID()
            }
            .onAppear {
                calendarHeight = mode.calendarHeight
            }
            .onChange(of: mode) {
                calendarHeight = mode.calendarHeight
            }
        }
        .frame(height: calendarHeight)
        .clipped()
    }
}
