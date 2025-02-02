//
//  CGFloat+.swift
//  Presentation
//
//  Created by 박민서 on 2/3/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

public extension CGFloat {
    /// 상단 safeArea
    static var safeAreaTop: CGFloat {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
            .first else { return 44 }
        
        let topInset = window.safeAreaInsets.top
        return topInset > 0 ? topInset : 0
    }
    
    /// 하단 safeArea
    static var safeAreaBottom: CGFloat {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
            .first else { return 34 }
        
        let bottomInset = window.safeAreaInsets.bottom
        return bottomInset > 0 ? bottomInset : 34
    }
}
