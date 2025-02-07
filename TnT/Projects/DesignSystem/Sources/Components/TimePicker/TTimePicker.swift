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
    /// 선택된 시간이 종합되는 date
    @Binding private var date: Date
    /// 0 ~ 11 (표시 시에는 +1 해서 1~12)
    @State private var selectedHour: Int
    /// 분 선택은 내부적으로 분 배열의 인덱스로 저장 (예, minuteStep이 5면 0~11)
    @State private var selectedMinuteIndex: Int
    /// 0: AM, 1: PM
    @State private var selectedPeriod: Int
    
    /// 셀 높이
    let rowHeight: CGFloat = 35
    /// 피커에 표시되는 셀 개수
    let visibleCount: Int = 5
    /// 선택되지 않은 시간 텍스트 폰트
    let normalFont: Font = Typography.FontStyle.heading4.font
    /// 선택된 시간 텍스트 폰트
    let selectedFont: Font = Typography.FontStyle.heading3.font
    /// 선택되지 않은 시간 텍스트 컬러
    let normalColor: Color = .neutral400
    /// 선택된 시간 텍스트 컬러
    let selectedColor: Color = .neutral900
    /// 분 단위 설정
    let minuteStep: Int
    // 무한 스크롤 사용 여부 - false로 설정하면 유한 스크롤
    let infiniteScroll: Bool = true
    /// 실제 분 값을 계산
    /// ex - minuteStep이 5이면 내부 저장값 7 -> 35분
    public var selectedMinute: Int {
        selectedMinuteIndex * minuteStep
    }
    
    public init(selectedDate: Binding<Date>, minuteStep: Int = 1) {
        _date = selectedDate
        
        let hour24 = Calendar.current.component(.hour, from: selectedDate.wrappedValue)
        let hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12
        let hour = hour12 - 1
        _selectedHour = State(initialValue: hour)
        
        let minute = Calendar.current.component(.minute, from: selectedDate.wrappedValue)
        _selectedMinuteIndex = State(initialValue: minute / minuteStep)
        
        _selectedPeriod = State(initialValue: hour24 < 12 ? 0 : 1)
        self.minuteStep = minuteStep
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
                    selected: Binding(get: {
                        selectedHour
                    }, set: {
                        selectedHour = $0
                        updateDate()
                    })
                )
                Text(":")
                    .typographyStyle(.heading4, with: .neutral900)
                // 분 열: 생성 시 minuteStep에 따라 아이템 생성 (예, minuteStep 5 → ["00","05",..., "55"])
                FlatPickerColumn(
                    items: stride(from: 0, to: 60, by: minuteStep)
                        .map { String(format: "%02d", $0) },
                    rowHeight: rowHeight,
                    visibleCount: visibleCount,
                    normalFont: normalFont,
                    selectedFont: selectedFont,
                    normalColor: normalColor,
                    selectedColor: selectedColor,
                    infiniteScroll: infiniteScroll,
                    selected: Binding(
                        get: { selectedMinuteIndex },
                        set: { newValue in
                            selectedMinuteIndex = newValue
                            updateDate()
                        }
                    )
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
                    selected: Binding(
                        get: { selectedPeriod },
                        set: { newValue in
                            selectedPeriod = newValue
                            updateDate()
                        }
                    )
                )
            }
        }
    }
    
    private func updateDate() {
        var calendar: Calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current  // UTC로 설정
        var components: DateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        // 24시간대로 시간 포맷 설정
        let hour24: Int = (selectedHour + 1) % 12 + (selectedPeriod == 1 ? 12 : 0)
        
        components.hour = hour24
        components.minute = selectedMinute
        
        if let newDate = calendar.date(from: components) {
            date = newDate
        }
    }
}
