//
//  OnboardingView.swift
//  Presentation
//
//  Created by 박서연 on 1/24/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct OnboardingView: View {
    @Bindable public var store: StoreOf<OnboardingFeature>
    
    public init(store: StoreOf<OnboardingFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            VStack {
                Spacer().frame(height: 48)
                VStack(spacing: 12) {
                    Text("만나서 반가워요!")
                        .typographyStyle(.body1Medium, with: .neutral500)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("트레이너와 트레이니\n케미 터트리기")
                        .typographyStyle(.heading1, with: .neutral950)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
                
                Image(.imgOnboardingLogin)
                
                Spacer()
                
                VStack(spacing: 8) {
                    ForEach(LoginType.allCases, id: \.self) { type in
                        HStack(spacing: 4) {
                            Image(type.image)
                                .resizable()
                                .frame(width: type.size, height: type.size)
                            Text(type.title)
                                .typographyStyle(.body1Medium, with: type.textColor)
                        }
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(type.background)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .onTapGesture {
                            store.send(.move(.toTermview))
    //                        type == .kakao
    //                        ? store.send(.view(.tappedAppleLogin))
    //                        : store.send(.view(.tappedAppleLogin))
                        }
                    }
                }
                .padding(.bottom, 62)
            }
            .padding(.horizontal, 28)
            .navigationBarBackButtonHidden()
        } destination: { store in
            switch store.case {
            case .term(let store):
                TermView(store: store)
//            case .selectRole(let store):
//                Text("selectRole") // 역할 선택 화면으로 추후 수정
//            case .registerNickname(let store):
//                EmptyView() // 프로필 생성 (이름+사진) 공통 화면으로 추후 수정
            case .completeSignup(let store):
                TrainerSignUpCompleteView(store: store)
            case .makeInvitationCode(let store):
                MakeInvitationCodeView(store: store)
            default:
                EmptyView()
            }
        }
    }
}

public enum LoginType: String, CaseIterable {
    case apple
    case kakao
    
    var title: String {
        switch self {
        case .kakao:
            return "카카오로 계속하기"
        case .apple:
            return "애플로 계속하기"
        }
    }
    
    var image: ImageResource {
        switch self {
        case .kakao:
            return .icKakao
        case .apple:
            return .icApple
        }
    }
    
    var background: Color {
        switch self {
        case .kakao:
            return .yellow
        case .apple:
            return .neutral900
        }
    }
    
    var textColor: Color {
        switch self {
        case .kakao:
            return .neutral900
        case .apple:
            return .common0
        }
    }
    
    var size: CGFloat {
        switch self {
        case .kakao, .apple:
            return 24
        }
    }
}
