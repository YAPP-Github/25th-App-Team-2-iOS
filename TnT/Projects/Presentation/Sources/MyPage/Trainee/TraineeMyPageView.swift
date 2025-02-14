//
//  TraineeMyPageView.swift
//  Presentation
//
//  Created by 박민서 on 2/3/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import Domain
import DesignSystem

@ViewAction(for: TraineeMyPageFeature.self)
public struct TraineeMyPageView: View {
    
    @Bindable public var store: StoreOf<TraineeMyPageFeature>
    @Environment(\.scenePhase) private var scenePhase
    
    public init(store: StoreOf<TraineeMyPageFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ProfileSection()
                
                VStack(spacing: 12) {
                    TopItemSection()
                    InfoItemSection()
                    BottomItemSection()
                }
                .padding(20) 
            }
        }
        .onAppear { send(.onAppear) }
        .onChange(of: scenePhase) { send(.onAppear) }
        .background(Color.neutral50)
        .navigationBarBackButtonHidden()
        .tPopUp(isPresented: $store.view_isPopUpPresented) {
            PopUpView()
        }
    }
    
    // MARK: - Sections
    @ViewBuilder
    private func ProfileSection() -> some View {
        VStack(spacing: 0) {
            ProfileImageView(imageURL: store.userImageUrl, name: store.userName)
                .padding(.vertical, 12)
            
            Text(store.userName)
                .typographyStyle(.heading2, with: .neutral950)
                .padding(.bottom, store.view_isTrainerConnected ? 8 : 16)
            
            if store.view_isTrainerConnected {
                TButton(
                    title: "개인정보 수정",
                    config: .small,
                    state: .default(.gray(isEnabled: true)),
                    action: { send(.tapEditProfileButton) }
                )
                .frame(width: 90, height: 34)
            }
        }
    }
    
    @ViewBuilder
    private func TopItemSection() -> some View {
        VStack(spacing: 12) {
            if !store.isConnected {
                ProfileItemView(title: "트레이너 연결하기", tapAction: { send(.tapConnectTrainerButton) })
                    .padding(.vertical, 4)
                    .background(Color.common0)
                    .clipShape(.rect(cornerRadius: 12))
            }
            
            ProfileItemView(title: "앱 푸시 알림", rightView: {
                Toggle("appPushNotification", isOn: $store.appPushNotificationAllowed)
                    .applyTToggleStyle()
            })
                .padding(.vertical, 4)
                .background(Color.common0)
                .clipShape(.rect(cornerRadius: 12))
        }
    }
    
    @ViewBuilder
    private func InfoItemSection() -> some View {
        VStack(spacing: 12) {
            ProfileItemView(title: "서비스 이용약관", tapAction: { send(.tapTOSButton) })
            ProfileItemView(title: "개인정보 처리방침", tapAction: { send(.tapPrivacyPolicyButton) })
            ProfileItemView(title: "버전 정보", rightView: {
                Text("0.0.1")
                    .typographyStyle(.body2Medium, with: .neutral400)
            })
            ProfileItemView(title: "오픈소스 라이선스", tapAction: { send(.tapOpenSourceLicenseButton) })
        }
        .padding(.vertical, 12)
        .background(Color.common0)
        .clipShape(.rect(cornerRadius: 12))
    }
    
    @ViewBuilder
    private func BottomItemSection() -> some View {
        VStack(spacing: 12) {
            if store.view_isTrainerConnected {
                ProfileItemView(title: "트레이너와 연결끊기", tapAction: { send(.tapDisconnectTrainerButton) })
                    .padding(.vertical, 4)
                    .background(Color.common0)
                    .clipShape(.rect(cornerRadius: 12))
            }
            
            VStack(spacing: 12) {
                ProfileItemView(title: "로그아웃", tapAction: { send(.tapLogoutButton) })
                ProfileItemView(title: "계정 탈퇴", tapAction: { send(.tapWithdrawButton) })
            }
            .padding(.vertical, 12)
            .background(Color.common0)
            .clipShape(.rect(cornerRadius: 12))
        }
    }
    
    @ViewBuilder
    private func PopUpView() -> some View {
        if let popUp = store.view_popUp {
            // secondaryAction nil 인 경우 제외하고 버튼 배열 구성
            let buttons: [TPopupAlertState.ButtonState] = [
                popUp.secondaryAction.map { action in
                    .init(title: "취소", style: .secondary, action: .init(action: { send(action) }))
                },
                .init(title: "확인", style: .primary, action: .init(action: { send(popUp.primaryAction) }))
            ].compactMap { $0 }
            
            TPopUpAlertView(
                alertState: .init(
                    title: popUp.title,
                    message: popUp.message,
                    showAlertIcon: popUp.showAlertIcon,
                    buttons: buttons
                )
            )
        } else {
            EmptyView()
        }
    }
}

private extension TraineeMyPageView {
    struct ProfileImageView: View {
        let imageURL: String?
        let name: String
        
        var body: some View {
            if let urlString = imageURL, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .tint(.red500)
                            .frame(width: 132, height: 132)
                        
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 132, height: 132)
                            .clipShape(Circle())
                        
                    case .failure:
                        Image(.imgDefaultTraineeImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 132, height: 132)
                            .clipShape(Circle())
                        
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(.imgDefaultTraineeImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 132, height: 132)
                    .clipShape(Circle())
            }
        }
    }
    
    struct ProfileItemView<RightView: View>: View {
        let title: String
        let rightView: () -> RightView
        let tapAction: (() -> Void)?
        
        init(
            title: String,
            rightView: @escaping () -> RightView = { EmptyView() },
            tapAction: (() -> Void)? = nil
        ) {
            self.title = title
            self.rightView = rightView
            self.tapAction = tapAction
        }
        
        var body: some View {
            HStack {
                Text(title)
                    .typographyStyle(.body2Medium, with: .neutral700)
                Spacer()
                rightView()
            }
            .onTapGesture {
                tapAction?()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
        }
    }
}
