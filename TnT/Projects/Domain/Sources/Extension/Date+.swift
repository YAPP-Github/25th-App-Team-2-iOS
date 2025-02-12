//
//  Date+.swift
//  Domain
//
//  Created by 박민서 on 1/25/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

public extension Date {
    /// Date를 문자열로 변환
    func toString(format: TDateFormat) -> String {
        return TDateFormatUtility.formatter(for: format).string(from: self)
    }
}
