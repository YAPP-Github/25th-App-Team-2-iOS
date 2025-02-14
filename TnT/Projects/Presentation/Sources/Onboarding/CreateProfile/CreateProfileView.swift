//
//  CreateProfileView.swift
//  Presentation
//
//  Created by 박민서 on 1/17/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import PhotosUI
import ComposableArchitecture

import Domain
import DesignSystem

/// 역할 선택 화면을 담당하는 View입니다.
@ViewAction(for: CreateProfileFeature.self)
public struct CreateProfileView: View {
    
    @Bindable public var store: StoreOf<CreateProfileFeature>
    @Environment(\.dismiss) var dismiss: DismissAction
    
    /// `CreateProfileView`의 생성자
    /// - Parameter store: `CreateProfileFeature`의 상태를 관리하는 `Store`
    public init(store: StoreOf<CreateProfileFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            TNavigation(type: .LButton(leftImage: .icnArrowLeft), leftAction: {
                dismiss()
            })
            
            Header()
            
            VStack(spacing: 24) {
                
                ImageSection()
                
                TextFieldSection()
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .keyboardDismissOnTap()
        .safeAreaInset(edge: .bottom) {
            TBottomButton(
                title: "다음",
                isEnable: store.view_isNextButtonEnabled
            ) {
                send(.tapNextButton)
            }
        }
    }
    
    @ViewBuilder
    private func Header() -> some View {
        VStack(spacing: 12) {
            if store.userType == .trainee {
                // 페이지 인디케이터
                HStack(spacing: 4) {
                    ForEach(1...4, id: \.self) { num in
                        TPageIndicator(pageNumber: num, isCurrent: num == 1)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
            }
            
            TInfoTitleHeader(title: "이름이 어떻게 되세요?")
        }
        .padding(.vertical, 12)
    }
    
    @ViewBuilder
    private func ImageSection() -> some View {
        Group {
            if let imageData = store.userImageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
            } else {
                Image(store.userType == .trainer
                      ? .imgDefaultTrainerImage
                      : .imgDefaultTraineeImage
                )
                .resizable()
                .clipShape(Circle())
            }
        }
        .frame(width: 132, height: 132)
        .overlay(alignment: .bottomTrailing) {
            PhotosPicker(
                selection: $store.view_photoPickerItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                ZStack {
                    Circle()
                        .fill(Color.neutral900)
                        .frame(width: 28, height: 28)
                    Image(.icnWriteWhite)
                        .resizable()
                        .frame(width: 16, height: 16)
                }
            }
        }
    }
    
    @ViewBuilder
    private func TextFieldSection() -> some View {
        TTextField(
            placeholder: "이름을 입력해주세요",
            text: $store.userName,
            textFieldStatus: $store.view_textFieldStatus
        )
        .withSectionLayout(
            header: .init(
                isRequired: true,
                title: "이름",
                limitCount: store.view_nameMaxLength ?? 15,
                textCount: store.userName.count
            ),
            footer: .init(
                footerText: store.view_isFooterTextVisible
                ? "\(store.view_nameMaxLength ?? 15)자 미만의 한글 또는 영문으로 입력해주세요"
                : "",
                status: store.view_textFieldStatus
            )
        )
        .padding(.horizontal, 20)
    }
}
