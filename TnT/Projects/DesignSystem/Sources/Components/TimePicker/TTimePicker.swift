//
//  TTimePicker.swift
//  DesignSystem
//
//  Created by 박민서 on 2/6/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// 시간, 분, 오전/오후 세 열을 나란히 배치하는 커스텀 타임 피커
public struct TTimePicker: View {
    @State private var selectedHour: Int    // 0 ~ 11 (표시 시에는 +1 해서 1~12)
    @State private var selectedMinute: Int     // 0 ~ 59
    @State private var selectedPeriod: Int    // 0: AM, 1: PM
    
    // 설정값
    let rowHeight: CGFloat = 35
    let visibleCount: Int = 5
    let normalFont: Font = Typography.FontStyle.heading4.font
    let selectedFont: Font = Typography.FontStyle.heading3.font
    let normalColor: Color = .neutral400
    let selectedColor: Color = .neutral900
    
    // 무한 스크롤 사용 여부 (여기서 전체 피커에 대해 동일하게 설정할 수 있음)
    let infiniteScroll: Bool = true // false로 설정하면 유한 스크롤이 됩니다.
    
    /// 현재 날짜와 시각을 기준으로 기본 선택값을 지정하는 initializer
        public init(
            selectedHour: Int = {
                let calendar = Calendar.current
                let hour24 = calendar.component(.hour, from: .now)
                // 12시간제로 변환 (0일 경우 12로, 나머지는 그대로)
                let hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12
                // TTimePicker는 0이 "1시", 11이 "12시"에 해당하므로 -1 처리
                return hour12 - 1
            }(),
            selectedMinute: Int = Calendar.current.component(.minute, from: .now),
            selectedPeriod: Int = {
                let hour24 = Calendar.current.component(.hour, from: .now)
                // 0: AM, 1: PM (오전이면 0, 오후면 1)
                return hour24 < 12 ? 0 : 1
            }()
        ) {
            _selectedHour = State(initialValue: selectedHour)
            _selectedMinute = State(initialValue: selectedMinute)
            _selectedPeriod = State(initialValue: selectedPeriod)
        }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.neutral100)
                .frame(height: rowHeight)
            
            HStack(spacing: 0) {
                // 시간 열: "1" ~ "12"
                FlatPickerColumn(
                    items: (1...12).map { "\($0)" },
                    rowHeight: rowHeight,
                    visibleCount: visibleCount,
                    normalFont: normalFont,
                    selectedFont: selectedFont,
                    normalColor: normalColor,
                    selectedColor: selectedColor,
                    infiniteScroll: infiniteScroll,
                    selected: $selectedHour
                )
                Text(":")
                    .typographyStyle(.heading4, with: .neutral900)
                // 분 열: "00" ~ "59"
                FlatPickerColumn(
                    items: (0..<60).map { String(format: "%02d", $0) },
                    rowHeight: rowHeight,
                    visibleCount: visibleCount,
                    normalFont: normalFont,
                    selectedFont: selectedFont,
                    normalColor: normalColor,
                    selectedColor: selectedColor,
                    infiniteScroll: infiniteScroll,
                    selected: $selectedMinute
                )
                Text(":")
                    .typographyStyle(.heading4, with: .clear)
                // 오전/오후 열: "오전", "오후"
                FlatPickerColumn(
                    items: ["오전", "오후"],
                    rowHeight: rowHeight,
                    visibleCount: visibleCount,
                    normalFont: normalFont,
                    selectedFont: selectedFont,
                    normalColor: normalColor,
                    selectedColor: selectedColor,
                    infiniteScroll: false,
                    selected: $selectedPeriod
                )
            }
        }
    }
}
