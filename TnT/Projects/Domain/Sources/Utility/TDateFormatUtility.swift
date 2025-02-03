//
//  TDateFormatUtility.swift
//  Domain
//
//  Created by 박민서 on 1/24/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

public enum TDateFormatUtility {
    /// `NSCache`를 활용한 포맷별 `DateFormatter` 캐싱
    private static let cache: NSCache<NSString, DateFormatter> = {
        let cache: NSCache = NSCache<NSString, DateFormatter>()
        return cache
    }()
    
    /// 포맷에 맞는 `DateFormatter` 반환 (캐싱된 인스턴스 재사용)
    public static func formatter(for format: TDateFormat) -> DateFormatter {
        // 캐시된 DateFormatter가 있으면 반환, 없으면 생성 후 저장
        if let cachedFormatter = cache.object(forKey: format.rawValue as NSString) {
            return cachedFormatter
        }
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = .current
        
        cache.setObject(formatter, forKey: format.rawValue as NSString)
        return formatter
    }
}
