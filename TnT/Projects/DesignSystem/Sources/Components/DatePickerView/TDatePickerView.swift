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
    /// 선택 날짜
    @State private var selectedDate: Date = .now
    
    /// `TDatePickerView` 생성자
    /// - Parameters:
    ///   - selectedDate: 초기 선택 날짜 (기본값: 현재 날짜)
    ///   - title: DatePicker의 제목
    ///   - buttonAction: 날짜 선택 후 실행할 액션
    public init(
        selectedDate: Date = .now,
        title: String,
        buttonAction: @escaping (Date) -> Void
    ) {
        self.selectedDate = selectedDate
        self.title = title
        self.buttonAction = buttonAction
    }
    
    public var body: some View {
        VStack {
            DatePicker(
                title,
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .tint(Color.red500)
            .datePickerStyle(.graphical)
            .labelsHidden()
            .padding()
            
            TBottomButton(
                title: "완료",
                isEnable: true,
                action: {
                    buttonAction(selectedDate)
                }
            )
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}
