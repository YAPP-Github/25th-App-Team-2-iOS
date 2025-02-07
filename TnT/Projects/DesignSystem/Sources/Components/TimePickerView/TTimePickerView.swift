//
//  TTimePickerView.swift
//  DesignSystem
//
//  Created by 박민서 on 2/7/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// - 시간 선택할 수 있는 TimePicker View
public struct TTimePickerView: View {
    
    /// picker 제목
    private let title: String
    /// 버튼 실행 action
    private let buttonAction: (Date) -> Void
    /// TimePicker 분단위
    private let minuteStep: Int
    /// 선택 시간
    @State private var selectedTime: Date = .now
    
    @Environment(\.dismiss) var dismiss
    
    /// `TTimePickerView` 생성자
    /// - Parameters:
    ///   - selectedTime: 초기 선택 시간 (기본값: 현재 시간)
    ///   - title: TimePicker의 제목
    ///   - buttonAction: 시간 선택 후 실행할 액션
    public init(
        selectedTime: Date = .now,
        title: String,
        minuteStep: Int = 1,
        buttonAction: @escaping (Date) -> Void
    ) {
        self.selectedTime = selectedTime
        self.title = title
        self.minuteStep = minuteStep
        self.buttonAction = buttonAction
    }
    
    public var body: some View {
        VStack(spacing: 24) {
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
            
            TTimePicker(
                selectedDate: $selectedTime,
                minuteStep: minuteStep
            )
            .padding(.horizontal, 20)
            
            TButton(
                title: "확인",
                config: .large,
                state: .default(.primary(isEnabled: true)),
                action: {
                    buttonAction(selectedTime)
                }
            )
            .padding(20)
        }
    }
}
