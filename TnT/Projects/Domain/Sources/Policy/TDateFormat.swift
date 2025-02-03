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
    /// "yyyy년 MM월"
    case yyyy년_MM월 = "yyyy년 MM월"
    /// "MM-dd"
    case MMdd = "MM-dd"
    /// "yyyy/MM/dd"
    case yyyyMMddSlash = "yyyy/MM/dd"
    /// "yyyy.MM.dd"
    case yyyyMMddDot = "yyyy.MM.dd"
    /// "01월 10일 화요일"
    case MM월_dd일_EEEE = "MM월 dd일 EEEE"
    /// "EE"
    case EE = "EE"
    /// "오후 17:00" (시간 포맷)
    case a_HHmm = "a HH:mm"
}
