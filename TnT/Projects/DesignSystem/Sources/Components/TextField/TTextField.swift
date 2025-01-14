//
//  TTextField.swift
//  DesignSystem
//
//  Created by 박민서 on 1/14/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

enum TextFieldStatus {
    case empty
    case focused
    case invalid
    case filled
}

struct TTextField: View {
    // 필수 속성
    let placeholder: String
    let limitCount: Int
    
    // 바인딩 상태
    @Binding var text: String
    @Binding var textFieldStatus: TextFieldStatus
    
    // 선택 속성
    let header: String?
    let footer: String?
    let rightButtonAction: (() -> Void)?
    let unitText: String?
    
    // 내부 상태
    private var lineColor: Color {
        switch textFieldStatus {
        case .empty: return .gray
        case .focused: return .blue
        case .invalid: return .red
        case .filled: return .green
        }
    }

    private var textColor: Color {
        return textFieldStatus == .invalid ? .red : .black
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header (옵션)
            if let header = header {
                Text(header)
                    .font(.headline)
            }
            
            // 텍스트 필드 영역
            HStack {
                TextField(placeholder, text: $text, onEditingChanged: { isEditing in
                    textFieldStatus = isEditing ? .focused : (text.isEmpty ? .empty : .filled)
                })
                .onChange(of: text) { newValue in
                    if newValue.count > limitCount {
                        text = String(newValue.prefix(limitCount))
                        textFieldStatus = .invalid
                    } else if !newValue.isEmpty {
                        textFieldStatus = .filled
                    } else {
                        textFieldStatus = .empty
                    }
                }
                .foregroundColor(textColor)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineColor, lineWidth: 1)
                )
                .keyboardType(.default)
                
                // Right Button (옵션)
                if let action = rightButtonAction {
                    Button(action: action) {
                        Image(systemName: "arrow.right")
                            .foregroundColor(.blue)
                            .padding(8)
                            .background(Circle().fill(Color.gray.opacity(0.2)))
                    }
                }
                
                // 단위 텍스트 (옵션)
                if let unit = unitText {
                    Text(unit)
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                }
            }
            
            // Footer (옵션)
            if let footer = footer {
                Text(footer)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TTextField(
        placeholder: "example",
        limitCount: 20,
        text: .constant("ㅅㄷㄴㅅㄷㄴㅅㄷ"),
        textFieldStatus: .constant(.filled),
        header: "오호라",
        footer: "오호라2",
        rightButtonAction: {
            print("action")
        },
        unitText: "???"
    )
}
