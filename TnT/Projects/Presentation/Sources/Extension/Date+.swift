//
//  Date+.swift
//  Presentation
//
//  Created by 박민서 on 2/2/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

import Domain

extension Date {
    func timeAgoDisplay() -> String {
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.second, .minute, .hour, .day], from: self, to: now)
        
        if let day = components.day, day >= 1 {
            return TDateFormatUtility.formatter(for: .M월_d일).string(from: self)
        } else if let hour = components.hour, hour >= 1 {
            return "\(hour)시간 전"
        } else if let minute = components.minute, minute >= 1 {
            return "\(minute)분 전"
        } else {
            return "방금"
        }
    }
}
