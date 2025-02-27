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
    /// 캘린더 높이
    @Binding var calendarHeight: CGFloat
    /// 주간/월간/컴팩트 모드인지 표시
    private var mode: TCalendarType = .month
    /// 캘린더 표시 이벤트 딕셔너리
    private var events: [Date: Int]
    
    public init(
        selectedDate: Binding<Date>,
        currentPage: Binding<Date>,
        calendarHeight: Binding<CGFloat>,
        mode: TCalendarType = .month,
        events: [Date: Int] = [:]
    ) {
        self._selectedDate = selectedDate
        self._currentPage = currentPage
        self._calendarHeight = calendarHeight
        self.mode = mode
        self.events = events
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeUIView(context: Context) -> FSCalendar {
        let calendar: FSCalendar = FSCalendar()
        
        // Cell 설정
        calendar.register(TCalendarCell.self, forCellReuseIdentifier: TCalendarCell.identifier)
        calendar.collectionView.contentSize = mode.cellSize
        
        // 기본 설정
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        calendar.locale = Locale(identifier: "ko_KR")
        
        // UI 설정
        calendar.placeholderType = .none
        calendar.headerHeight = 0
        calendar.weekdayHeight = 18
        calendar.rowHeight = mode.cellSize.height
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
        let targetScope: FSCalendarScope = mode.scope
        if uiView.scope != targetScope {
            uiView.scope = targetScope
        }
        
        DispatchQueue.main.async {
            uiView.bounds.size.height = self.calendarHeight
            uiView.frame.size.height = self.calendarHeight
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
        
        // Week/Month 모드 전환
        public func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
            DispatchQueue.main.async {
                calendar.bounds.size.height = bounds.height
                calendar.frame.size.height = bounds.height
                calendar.setNeedsLayout()
                calendar.layoutIfNeeded()
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
                mode: parent.mode
            )
            
            return cell
        }
    }
}
