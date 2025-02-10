//
//  Color+.swift
//  Presentation
//
//  Created by 박민서 on 2/8/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

public extension Color {
    /// 헥스 문자열(#RRGGBB 또는 #RRGGBBAA)을 사용하여 Color를 초기화합니다.
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let hexString = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        let r, g, b, a: Double
        
        switch hexString.count {
        case 8: // RRGGBBAA
            r = Double((rgbValue & 0xFF000000) >> 24) / 255.0
            g = Double((rgbValue & 0x00FF0000) >> 16) / 255.0
            b = Double((rgbValue & 0x0000FF00) >> 8)  / 255.0
            a = Double(rgbValue & 0x000000FF)         / 255.0
        case 6: // RRGGBB
            r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
            g = Double((rgbValue & 0x00FF00) >> 8)  / 255.0
            b = Double(rgbValue & 0x0000FF)         / 255.0
            a = 1.0
        default:
            r = 1.0; g = 1.0; b = 1.0; a = 1.0
        }
        
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}
