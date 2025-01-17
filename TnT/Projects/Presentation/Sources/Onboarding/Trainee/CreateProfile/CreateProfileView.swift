//
//  CreateProfileView.swift
//  Presentation
//
//  Created by 박민서 on 1/17/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import PhotosUI

import Domain
import DesignSystem

/// 역할 선택 화면을 담당하는 View입니다.
@ViewAction(for: CreateProfileFeature.self)
public struct CreateProfileView: View {
    
    public var store: StoreOf<CreateProfileFeature>
    
    /// `CreateProfileView`의 생성자
    /// - Parameter store: `CreateProfileFeature`의 상태를 관리하는 `Store`
    public init(store: StoreOf<CreateProfileFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            
            Header
            
            VStack(spacing: 24) {
                
                ImageSection
                
                TextFieldSection
            }
            
            Spacer()
            
            BottomTempButton(isEnabled: store.viewState.isNextButtonEnabled) {
                send(.tapNextButton)
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

// MARK: - SubViews
private extension CreateProfileView {
    var Header: some View {
        Text("이름이 어떻게 되세요?")
            .typographyStyle(.heading2, with: .neutral950)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.bottom, 48)
    }
    
    var ImageSection: some View {
        Group {
            if let imageData = store.userImageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .clipShape(Circle())
            } else {
                if store.userType == .trainer {
                    Image(.imgDefaultTrainerImage)
                        .resizable()
                        .clipShape(Circle())
                } else {
                    Image(.imgDefaultTraineeImage)
                        .resizable()
                        .clipShape(Circle())
                }
            }
        }
        .frame(width: 132, height: 132)
        .overlay(alignment: .bottomTrailing) {
            PhotosPicker(
                selection: Binding(get: {
                    store.viewState.photoPickerItem
                }, set: {
                    send(.tapImageInPicker($0))
                }),
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
    
    var TextFieldSection: some View {
        TTextField(
            placeholder: "이름을 입력해주세요",
            text: Binding(get: {
                store.userName
            }, set: {
                send(.typeUserName($0))
            }),
            textFieldStatus: Binding(get: {
                store.viewState.textFieldStatus
            }, set: {
                send(.updateTextFieldStatus($0))
            })
        )
        .withSectionLayout(
            header: .init(
                isRequired: true,
                title: "이름",
                limitCount: UserPolicy.maxNameLength,
                textCount: store.userName.count
            ),
            footer: .init(
                footerText: store.viewState.showFooterText
                ? "\(UserPolicy.maxNameLength)자 이하로 입력해주세요"
                : "",
                status: store.viewState.textFieldStatus
            )
        )
        .padding(.horizontal, 20)
    }
}

// TODO: 버튼 컴포넌트 나오면 대체
private extension CreateProfileView {    
    struct BottomTempButton: View {
        var isEnabled: Bool
        let action: (() -> Void)
        
        var body: some View {
            Button(action: {
                action()
            }) {
                Text("다음")
                    .typographyStyle(.heading4, with: .neutral50)
                    .padding(.top, 20)
                    .padding(.bottom, 53)
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .background(isEnabled ? Color.neutral900 : Color.neutral300)
                    .disabled(!isEnabled)
            }
        }
    }
}
