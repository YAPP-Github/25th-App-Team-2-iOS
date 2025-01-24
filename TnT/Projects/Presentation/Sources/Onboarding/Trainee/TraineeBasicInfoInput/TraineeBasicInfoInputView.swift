//
//  TraineeBasicInfoInputView.swift
//  Presentation
//
//  Created by 박민서 on 1/24/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import DesignSystem

public struct TraineeBasicInfoInputView: View {
    
//    public var store: StoreOf
    
    @Environment(\.dismiss) var dismiss: DismissAction
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            TNavigation(type: .LButton(leftImage: .icnArrowLeft), leftAction: {})
            
            Header
                .padding(.bottom, 32)
            
            TextFieldSection
            
            Spacer()
            
            TBottomButton(
                title: "다음",
                state: .true
            ) {
                print("asdf")
            }
            .ignoresSafeArea(.container, edges: .bottom)
        }
        .navigationBarBackButtonHidden()
    }
}

private extension TraineeBasicInfoInputView {
    var Header: some View {
        VStack(spacing: 12) {
            // PageIndicatorList
            HStack(spacing: 4) {
                ForEach(1...4, id: \.self) { num in
                    TPageIndicator(pageNumber: num, isCurrent: true)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            
            TInfoTitleHeader(title: "회원님의 기본 정보를\n입력해주세요", subTitle: "PT에 참고할 기본 정보에요!")
        }
        .padding(.vertical, 12)
    }
    
    var TextFieldSection: some View {
        VStack(spacing: 48) {
            TTextField(
                placeholder: "2000/01/01",
                text: .constant(""),
                textFieldStatus: .constant(.empty)
            )
            .withSectionLayout(header: .init(isRequired: false, title: "생년월일", limitCount: nil, textCount: nil))
            .keyboardType(.numberPad)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            
            HStack(spacing: 12) {
                TTextField(
                    placeholder: "0",
                    text: .constant(""),
                    textFieldStatus: .constant(.empty),
                    rightView: {
                        TTextField.RightView(style: .unit(text: "cm", status: .filled))
                    }
                )
                .withSectionLayout(header: .init(isRequired: true, title: "키", limitCount: nil, textCount: nil))
                .keyboardType(.numberPad)
                
                TTextField(
                    placeholder: "00.0",
                    text: .constant(""),
                    textFieldStatus: .constant(.empty),
                    rightView: {
                        TTextField.RightView(style: .unit(text: "kg", status: .filled))
                    }
                )
                .withSectionLayout(header: .init(isRequired: true, title: "체중", limitCount: nil, textCount: nil))
                .keyboardType(.decimalPad)
            }
            .padding(.horizontal, 20)
        }
    }
    
}
