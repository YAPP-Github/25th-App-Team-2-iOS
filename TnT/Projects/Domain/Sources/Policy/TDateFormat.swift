//
//  TDateFormat.swift
//  Domain
//
//  Created by 박민서 on 1/24/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 앱내에서 전반적으로 사용할 날짜 포맷 정의
public enum TDateFormat: String {
    ///  "yyyy-MM-dd"
    case yyyyMMdd = "yyyy-MM-dd"
    /// "yyyy-MM"
    case yyyyMM = "yyyy-MM"
    /// "MM-dd"
    case MMdd = "MM-dd"
    /// "yyyy/MM/dd"
    case yyyyMMddSlash = "yyyy/MM/dd"
    /// "yyyy.MM.dd"
    case yyyyMMddDot = "yyyy.MM.dd"
    /// "EE"
    case EE = "EE"
}
