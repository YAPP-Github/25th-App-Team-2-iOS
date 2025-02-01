//
//  TCalendarRepresentable.swift
//  DesignSystem
//
//  Created by 박민서 on 1/31/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import FSCalendar


public struct TCalendarRepresentable: UIViewRepresentable {
    /// 선택한 날짜
    @Binding private var selectedDate: Date
    /// 현재 페이지
    @Binding private var currentPage: Date
    /// 주간/월간 표시 여부
    private var isWeekMode: Bool
    /// 캘린더 표시 이벤트 딕셔너리
    private var events: [Date: Int]
    
    public init(
        selectedDate: Binding<Date>,
        currentPage: Binding<Date>,
        isWeekMode: Bool = false,
        events: [Date: Int] = [:]
    ) {
        self._selectedDate = selectedDate
        self._currentPage = currentPage
        self.isWeekMode = isWeekMode
        self.events = events
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeUIView(context: Context) -> FSCalendar {
        let calendar: FSCalendar = FSCalendar()
        // Cell 설정
        calendar.register(TCalendarCell.self, forCellReuseIdentifier: TCalendarCell.identifier)
        calendar.collectionView.contentSize = TCalendarCell.cellSize
        
        // 기본 설정
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        calendar.locale = Locale(identifier: "ko_KR")
        
        // UI 설정
        calendar.placeholderType = .none
        calendar.headerHeight = 0
        calendar.appearance.weekdayTextColor = UIColor(.neutral400)
        calendar.appearance.weekdayFont = Typography.FontStyle.label2Medium.uiFont
        calendar.appearance.selectionColor = .clear
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleSelectionColor = .clear
        calendar.appearance.titleDefaultColor = .clear
        calendar.calendarWeekdayView.weekdayLabels[0].textColor = UIColor(.red500)
        
        return calendar
    }
    
    public func updateUIView(_ uiView: FSCalendar, context: Context) {
        // `selectedDate` 반영
        uiView.select(selectedDate)
        
        // `currentPage` 반영
        if uiView.currentPage != currentPage {
            uiView.setCurrentPage(currentPage, animated: true)
        }
        
        // `isWeekMode` 반영
        let targetScope: FSCalendarScope = isWeekMode ? .week : .month
        if uiView.scope != targetScope {
            uiView.scope = targetScope
        }
        
        uiView.reloadData()
    }
}

public extension TCalendarRepresentable {
    final class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
        var parent: TCalendarRepresentable
        
        init(_ parent: TCalendarRepresentable) {
            self.parent = parent
        }
        
        // 날짜 선택 이벤트
        public func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            DispatchQueue.main.async {
                self.parent.selectedDate = date
                calendar.reloadData()
            }
        }
        
        // 현재 페이지 전환 이벤트
        public func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
            DispatchQueue.main.async {
                self.parent.currentPage = calendar.currentPage
            }
        }
        
        // 캘린더 셀 주입
        public func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
            
            guard let cell = calendar.dequeueReusableCell(withIdentifier: TCalendarCell.identifier, for: date, at: position) as? TCalendarCell else {
                return FSCalendarCell()
            }
            
            let isSelected: Bool = Calendar.current.isDate(parent.selectedDate, inSameDayAs: date)
            let eventCount: Int = parent.events[date] ?? 0
            cell.configure(
                with: date,
                isCellSelected: isSelected,
                eventCount: eventCount,
                isWeekMode: parent.isWeekMode
            )
            
            return cell
        }
    }
}
