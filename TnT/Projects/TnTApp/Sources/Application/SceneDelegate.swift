//
//  SceneDelegate.swift
//  TnT
//
//  Created by 박서연 on 1/4/25.
//  Copyright © 2025 yapp25-app2team. All rights reserved.
//

import UIKit
import Domain

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let notificationResponse = connectionOptions.notificationResponse {
            let userInfo = notificationResponse.notification.request.content.userInfo

            if let trainerIdString = userInfo["trainerId"] as? String,
               let trainerId = Int64(trainerIdString),
               let traineeIdString = userInfo["traineeId"] as? String,
               let traineeId = Int64(traineeIdString) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    NotificationCenter.default.post(
                        name: NSNotification.Name.fcmUserConnectedNotification,
                        object: nil,
                        userInfo: [
                            "trainerId": trainerId,
                            "traineeId": traineeId
                        ]
                    )
                }
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // 사용자가 앱을 종료할 때 실행되는 코드
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // 앱이 활성화되어 사용 가능한 상태가 되었을 때 실행되는 코드
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // 앱이 비활성화되어 일시 중지된 상태가 될 때 실행되는 코드
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // 앱이 백그라운드에서 포그라운드로 전환되기 직전에 실행되는 코드
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // 앱이 백그라운드로 들어갔을 때 실행되는 코드
    }
}
