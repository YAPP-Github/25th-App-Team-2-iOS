//
//  String+.swift
//  Domain
//
//  Created by 박민서 on 1/25/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

public extension String {
    /// 문자열을 Date로 변환
    func toDate(format: TDateFormat) -> Date? {
        return TDateFormatUtility.formatter(for: format).date(from: self)
    }
}
