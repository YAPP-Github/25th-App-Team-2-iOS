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
    
    /// 커스텀/시스템 캘린더 선택
    private let isCustom: Bool
    /// picker 제목
    private let title: String
    /// 버튼 실행 action
    private let buttonAction: (Date) -> Void
    /// 헤더 formatter
    private let monthFormatter: (Date) -> String
    /// 선택 날짜
    @State private var selectedDate: Date = .now
    /// 표시 날짜
    @State private var currentPageDate: Date = .now
    
    @Environment(\.dismiss) var dismiss
    
    /// `TDatePickerView` 생성자
    /// - Parameters:
    ///   - isCustom: 시스템 캘린더 / 커스텀 캘린더 선택 (기본값: 커스텀)
    ///   - selectedDate: 초기 선택 날짜 (기본값: 현재 날짜)
    ///   - currentPageDate: 초기 표시 날짜 (기본값: 현재 날짜)
    ///   - title: DatePicker의 제목
    ///   - buttonAction: 날짜 선택 후 실행할 액션
    public init(
        isCustom: Bool = true,
        selectedDate: Date = .now,
        currentPageDate: Date = .now,
        title: String,
        monthFormatter: @escaping (Date) -> String,
        buttonAction: @escaping (Date) -> Void
    ) {
        self.isCustom = isCustom
        self.selectedDate = selectedDate
        self.currentPageDate = currentPageDate
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
            
            Calendar(isCustom)
            
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
    
    @ViewBuilder
    private func Calendar(_ isCustom: Bool) -> some View {
        if isCustom {
            TCalendarHeader<EmptyView>(
                currentPage: $currentPageDate,
                formatter: monthFormatter
            )
            .padding(.top, 20)
            
            TCalendarView(
                selectedDate: $selectedDate,
                currentPage: $currentPageDate,
                mode: .compactMonth
            )
            .padding(.horizontal, 16)
        } else {
            DatePicker("날짜 선택", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .environment(\.locale, Locale(identifier: "ko_KR"))
                .tint(.red400)
                .padding(.top, 20)
                .padding(.horizontal, 16)
        }
    }
}
