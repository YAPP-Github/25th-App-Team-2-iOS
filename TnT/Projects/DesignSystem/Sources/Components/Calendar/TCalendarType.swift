//
//  TCalendarType.swift
//  DesignSystem
//
//  Created by 박민서 on 2/6/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import FSCalendar

/// TCalendar에 사용되는 캘린더 타입입니다
public enum TCalendarType {
    /// 주간 캘린더 - 일정 표시
    case week
    /// 월간 캘린더 - 일정 표시
    case month
    /// 월간 캘린더 - 날짜와 선택 표시만
    case compactMonth
    
    var scope: FSCalendarScope {
        switch self {
        case .week:
            return .week
        case .month, .compactMonth:
            return .month
        }
    }
    
    var calendarHeight: CGFloat {
        switch self {
        case .week:
            return 80
        case .month:
            return 340
        case .compactMonth:
            return 320
        }
    }
    
    var cellSize: CGSize {
        switch self {
        case .week, .month:
            return CGSize(width: 51, height: 54)
        case .compactMonth:
            return CGSize(width: 51, height: 40)
        }
    }
}
