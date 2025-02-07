//
//  RowPreference.swift
//  DesignSystem
//
//  Created by 박민서 on 2/6/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// 각 행의 인덱스와 해당 행의 중앙 Y 좌표를 저장
struct RowPreferenceData: Equatable {
    let index: Int
    let midY: CGFloat
}

/// 자식 뷰(행)에서 전달한 RowPreferenceData 배열을 모으는 PreferenceKey
struct RowPreferenceKey: PreferenceKey {
    static var defaultValue: [RowPreferenceData] = []
    static func reduce(value: inout [RowPreferenceData], nextValue: () -> [RowPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}
