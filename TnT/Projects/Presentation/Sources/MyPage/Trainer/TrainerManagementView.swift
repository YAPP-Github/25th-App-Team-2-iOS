//
//  TrainerManagementView.swift
//  Presentation
//
//  Created by 박서연 on 2/7/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import DesignSystem

/*
 @Reducer
 public struct TrainerMypageFeature {
     
     @ObservableState
     public struct State: Equatable {
         /// 사용자 이름
         var userName: String
         /// 사용자 이미지 URL
         var userImageUrl: String?
         /// 관리 중인 회원
         var studentCount: Int
         /// 함께 했던 회원
         var oldStudentCount: Int
         /// 앱 푸시 알림 허용 여부
         var appPushNotificationAllowed: Bool
         /// 버전 정보
         var versionInfo: String
         /// 팝업
         var view_popUp: PopUp?
         /// 팝업 표시 유무
         var view_isPopUpPresented: Bool = false
         
         public init(
             userName: String = "",
             userImageUrl: String? = nil,
             studentCount: Int = 0,
             oldStudentCount: Int = 0,
             appPushNotificationAllowed: Bool = false,
             versionInfo: String = "",
             view_popUp: PopUp? = nil,
             view_isPopUpPresented: Bool = false
         ) {
             self.userName = userName
             self.userImageUrl = userImageUrl
             self.studentCount = studentCount
             self.oldStudentCount = oldStudentCount
             self.appPushNotificationAllowed = appPushNotificationAllowed
             self.versionInfo = versionInfo
             self.view_popUp = view_popUp
             self.view_isPopUpPresented = view_isPopUpPresented
         }
     }
     
     @Dependency(\.userUseCase) private var userUseCase: UserUseCase
     
     public enum Action: Sendable, ViewAction {
         /// 뷰에서 발생한 액션을 처리합니다.
         case view(View)
         /// 네비게이션 여부 설정
         case setNavigating
         
         @CasePathable
         public enum View: Sendable, BindableAction {
             /// 바인딩할 액션을 처리 (알람)
             case binding(BindingAction<State>)
             /// 서비스 이용약관 버튼 탭
             case tapTOSButton
             /// 개인정보 처리방침 버튼 탭
             case tapPrivacyPolicyButton
             /// 오픈소스 라이선스 버튼 탭
             case tapOpenSourceLicenseButton
             /// 로그아웃 버튼 탭
             case tapLogoutButton
             /// 계정 탈퇴 버튼 탭
             case tapWithdrawButton
             /// 팝업 왼쪽 탭
             case tapPupUpSecondaryButton(popUp: PopUp?)
             /// 팝옵 오른쪽 탭
             case tapPopUpPrimaryButton(popUp: PopUp?)
         }
     }
     
     public init() { }
     
     public var body: some ReducerOf<Self> {
         BindingReducer(action: \.view)
         
         Reduce { state, action in
             switch action {
             case .view(let action):
 */

@Reducer
struct  TrainerManagementFeature {
    @ObservableState
    struct State {
        
    }
}

struct TrainerManagementView: View {
    var body: some View {
        VStack(spacing: 0) {
            TNavigation(type: .LTextRButtonTitle(
                leftTitle: "내 회원",
                pointText: "0",
                rightButton: "회원 초대하기")
            )
            
            VStack(spacing: 12) {
                HStack {
                    ProfileImageView(imageURL: "")
                    
                    VStack(spacing: 12) {
                        Text("")
                            .typographyStyle(.body1Bold, with: Color.neutral900)
                        Text("")
                            .typographyStyle(.label2Medium, with: Color.neutral500)
                    }
                }
                
                VStack(spacing: 5) {
                    Text("메모")
                        .typographyStyle(.label2Bold, with: Color.neutral600)
                    Text("")
                        .typographyStyle(.label2Medium, with: Color.neutral500)
                }
            }
            .padding(12)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    /// 연결된 회원이 없는 경우
    @ViewBuilder
    func EmptyListView() -> some View {
        VStack(spacing: 0) {
            TNavigation(type: .LTextRButtonTitle(
                leftTitle: "내 회원",
                pointText: "0",
                rightButton: "회원 초대하기")
            )
            
            Spacer()
            VStack(spacing: 4) {
                Text("아직 연결된 회원이 없어요")
                    .typographyStyle(.body2Bold, with: Color.neutral600)
                Text("추가 버튼을 눌러 회원을 추가해 보세요")
                    .typographyStyle(.label1Medium, with: Color.neutral400)
            }
            Spacer()
        }
    }
}

extension TrainerManagementView {
    struct ProfileImageView: View {
        let imageURL: String?
        
        var body: some View {
            if let urlString = imageURL, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .tint(.red500)
                            .frame(width: 60, height: 60)
                        
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                    case .failure:
                        Image(.imgDefaultTrainerImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(.imgDefaultTrainerImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 132, height: 132)
                    .clipShape(Circle())
            }
        }
    }
}

#Preview {
    TrainerManagementView()
}
