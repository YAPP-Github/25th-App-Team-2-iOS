//
//  TnTApp.swift
//  TnT
//
//  Created by 박서연 on 1/4/25.
//  Copyright © 2025 yapp25-app2team. All rights reserved.
//

import SwiftUI
import KakaoSDKAuth

import Presentation
import ComposableArchitecture
import DesignSystem

@main
struct ToyProjectApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        DesignSystemFontFamily.registerAllCustomFonts()
    }

    var body: some Scene {
        WindowGroup {
//            AppFlowCoordinatorView(
//                store: .init(
//                    initialState: AppFlowCoordinatorFeature.State(),
//                    reducer: { AppFlowCoordinatorFeature()
//                    })
//            )
//             .onOpenURL(perform: { url in
//                if AuthApi.isKakaoTalkLoginUrl(url) {
//                    debugPrint(AuthController.handleOpenUrl(url: url))
//                }
//            })
            ConnectedTraineeProfileView(
                store: .init(
                    initialState: ConnectedTraineeProfileFeature.State(
                        traineeProfile: .init(
                            traineeName: "테스트입니다테스트입니다123",
                            imageUrl: "https://www.aandmedu.in/wp-content/uploads/2021/11/9-16-Aspect-Ratio-576x1024.jpg",
                            age: nil,
                            height: nil,
                            weight: nil,
                            ptGoal: "",
                            cautionNote: ""
                        )
                    ),
                    reducer: {
                        ConnectedTraineeProfileFeature()
                    }
                )
            )
        }
    }
}
