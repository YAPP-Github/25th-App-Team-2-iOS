//
//  ScrollCalendarView.swift
//  DesignSystem
//
//  Created by 박민서 on 1/31/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import FSCalendar

public struct FSCalendarView: UIViewRepresentable {
    @Binding var selectedDate: Date
    @Binding var currentPage: Date
    var isWeekMode: Bool
    var events: [Date: Int]
    
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
    
    public class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
        var parent: FSCalendarView
        
        init(_ parent: FSCalendarView) {
            self.parent = parent
        }
        
        // 날짜 선택 이벤트
        public func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            DispatchQueue.main.async {
                self.parent.selectedDate = date
                calendar.reloadData()
            }
        }
        
        public func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
            DispatchQueue.main.async {
                self.parent.currentPage = calendar.currentPage
            }
        }
        
        public func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
            
            guard let cell = calendar.dequeueReusableCell(withIdentifier: FSCustomCalendarCell.identifier, for: date, at: position) as? FSCustomCalendarCell else {
                return FSCalendarCell()
            }
            
            let isSelected = Calendar.current.isDate(parent.selectedDate, inSameDayAs: date)
            let eventCount = parent.events[date] ?? 0
            cell.configure(
                with: date,
                isSelected: isSelected,
                eventCount: eventCount,
                isWeekMode: parent.isWeekMode
            )
            
            return cell
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.register(FSCustomCalendarCell.self, forCellReuseIdentifier: FSCustomCalendarCell.identifier)
        
        // 기본 설정
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.placeholderType = .none
        
        // 📌 FSCalendar 기본 설정
        calendar.headerHeight = 0
        // Weekday
        calendar.appearance.weekdayTextColor = UIColor(.neutral400)
        calendar.appearance.weekdayFont = Typography.FontStyle.label2Medium.uiFont
        // Today
        
        // Selected
        
        calendar.collectionView.contentSize = FSCustomCalendarCell.cellSize
        
        // Additional
        calendar.appearance.selectionColor = .clear
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleSelectionColor = .clear
        calendar.appearance.titleDefaultColor = .clear
        calendar.calendarWeekdayView.weekdayLabels[0].textColor = UIColor(.red500)
        
        print("너는 되니(\(events)")
        return calendar
    }
    
    public func updateUIView(_ uiView: FSCalendar, context: Context) {
        // 선택된 날짜 반영
        uiView.select(selectedDate)
        
        // ✅ SwiftUI에서 `currentMonth`가 바뀌었을 때만 `currentPage` 업데이트
        if uiView.currentPage != currentPage {
            uiView.setCurrentPage(currentPage, animated: true)
        }
        
        // ✅ 주간/월간 모드 변경
        let targetScope: FSCalendarScope = isWeekMode ? .week : .month
        if uiView.scope != targetScope {
            uiView.scope = targetScope
            uiView.reloadData()
        }
    }
}
