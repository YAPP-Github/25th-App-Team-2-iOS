//
//  TDateFormatUtility.swift
//  Domain
//
//  Created by 박민서 on 1/24/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

public final class TDateFormatUtility {
    
    /// 포맷별 `DateFormatter` 캐시
    private static var cache: [TDateFormat: DateFormatter] = [:]
    private static let queue: DispatchQueue = DispatchQueue(label: "com.TnT.DateFormatUtility", attributes: .concurrent)

    /// 포맷에 맞는 `DateFormatter` 반환 (캐싱된 인스턴스 재사용)
    static func formatter(for format: TDateFormat) -> DateFormatter {
        var result: DateFormatter?
        
        // sync - 동시 읽기 가능
        queue.sync {
            result = cache[format]
        }
        if let result {
            return result // 캐시 존재 시 early return
        }
        
        // Race Condition 방지를 위해 sync with barrier flag
        queue.sync(flags: .barrier) {
            if let cachedFormatter = cache[format] {
                result = cachedFormatter
            } else {
                let formatter: DateFormatter = DateFormatter()
                formatter.dateFormat = format.rawValue
                formatter.locale = Locale(identifier: "ko_KR")
                formatter.timeZone = .current
                
                cache[format] = formatter
                result = formatter
            }
        }
        
        // sync 블록이 모두 끝난 후 리턴
        return result ?? DateFormatter()
    }
}
