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
        TCalendarRepresentable(
            selectedDate: $selectedDate,
            currentPage: $currentPage,
            isWeekMode: isWeekMode,
            events: events
        )
        .id(forceUpdate)
        .onChange(of: events) {
            forceUpdate = UUID()
        }
    }
}
