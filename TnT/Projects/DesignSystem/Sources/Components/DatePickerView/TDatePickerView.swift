//
//  TDatePickerView.swift
//  DesignSystem
//
//  Created by 박민서 on 1/25/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// - 날짜 선택할 수 있는 DatePicker View
public struct TDatePickerView: View {
    
    /// picker 제목
    private let title: String
    /// 버튼 실행 action
    private let buttonAction: (Date) -> Void
    /// 헤더 formatter
    private let monthFormatter: (Date) -> String
    /// 선택 날짜
    @State private var selectedDate: Date = .now
    /// 표시 날짜
    @State private var currentDate: Date = .now
    
    @Environment(\.dismiss) var dismiss
    
    /// `TDatePickerView` 생성자
    /// - Parameters:
    ///   - selectedDate: 초기 선택 날짜 (기본값: 현재 날짜)
    ///   - title: DatePicker의 제목
    ///   - buttonAction: 날짜 선택 후 실행할 액션
    public init(
        selectedDate: Date = .now,
        title: String,
        monthFormatter: @escaping (Date) -> String,
        buttonAction: @escaping (Date) -> Void
    ) {
        self.selectedDate = selectedDate
        self.title = title
        self.monthFormatter = monthFormatter
        self.buttonAction = buttonAction
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(title)
                    .typographyStyle(.heading3, with: .neutral900)
                Spacer()
                Button(action: {
                    dismiss()
                }, label: {
                    Image(.icnDelete)
                        .renderingMode(.template)
                        .resizable()
                        .tint(.neutral400)
                        .frame(width: 32, height: 32)
                })
            }
            .padding(20)
            
            TCalendarHeader<EmptyView>(
                currentPage: $currentDate,
                formatter: monthFormatter
            )
            .padding(.top, 20)
            
            TCalendarView(
                selectedDate: $selectedDate,
                currentPage: $currentDate,
                mode: .compactMonth
            )
            .padding(.horizontal, 16)
            
            TButton(
                title: "확인",
                config: .large,
                state: .default(.primary(isEnabled: true)),
                action: {
                    buttonAction(selectedDate)
                }
            )
            .padding(20)
        }
    }
}
