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
    
    /// 주간 캘린더 높이
    static let weeklyCalendarHeight: CGFloat = 80
    /// 월간 캘린더 높이
    static let monthlyCalendarHeight: CGFloat = 340
    /// 선택한 날짜
    @Binding var selectedDate: Date
    /// 현재 페이지
    @Binding var currentPage: Date
    /// 업데이트 플래그
    @State private var forceUpdate: UUID = UUID()
    /// 캘린더 높이
    @State private var calendarHeight: CGFloat = monthlyCalendarHeight
    /// 주간/월간 표시 여부
    private var isWeekMode: Bool
    /// 캘린더 표시 이벤트 딕셔너리
    private var events: [Date: Int]
    
    public init(
        selectedDate: Binding<Date>,
        currentPage: Binding<Date>,
        forceUpdate: UUID = UUID(),
        events: [Date: Int],
        isWeekMode: Bool = false
    ) {
        self._selectedDate = selectedDate
        self._currentPage = currentPage
        self.events = events
        self.forceUpdate = forceUpdate
        self.isWeekMode = isWeekMode
    }

    public var body: some View {
        GeometryReader { proxy in
            TCalendarRepresentable(
                selectedDate: $selectedDate,
                currentPage: $currentPage,
                calendarHeight: $calendarHeight,
                isWeekMode: isWeekMode,
                events: events
            )
            .frame(width: proxy.size.width, height: TCalendarView.monthlyCalendarHeight)
            .id(forceUpdate)
            .onChange(of: events) {
                forceUpdate = UUID()
            }
            .onAppear {
                calendarHeight = isWeekMode
                ? TCalendarView.weeklyCalendarHeight
                : TCalendarView.monthlyCalendarHeight
            }
            .onChange(of: isWeekMode) {
                calendarHeight = isWeekMode
                ? TCalendarView.weeklyCalendarHeight
                : TCalendarView.monthlyCalendarHeight
            }
        }
        .frame(height: calendarHeight)
        .clipped()
    }
}
