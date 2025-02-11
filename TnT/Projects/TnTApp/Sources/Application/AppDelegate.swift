//
//  AppDelegate.swift
//  TnT
//
//  Created by 박서연 on 1/4/25.
//  Copyright © 2025 yapp25-app2team. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

import Data

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /// Firebase 설정
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        /// FCM 메시징 델리게이트 설정
        Messaging.messaging().delegate = self
        
        /// 알림 권한 요청
        NotificationManager.shared.checkNotificationPermission()
        
        /// APNs 등록 요청
        UIApplication.shared.registerForRemoteNotifications()

        return true
    }

    // MARK: - APNs 등록 성공
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()

        do {
            try KeyChainManager.save(deviceToken, for: .apns)
        } catch {
            print("KeyChain 저장 중 오류 발생 \(error.localizedDescription)")
        }
        
        print("✅ APNs Device Token: \(tokenString)")
        Messaging.messaging().apnsToken = deviceToken
    }

    // MARK: - APNs 등록 실패
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("❌ APNs 등록 실패: \(error.localizedDescription)")
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    /// 포그라운드에서 알림 처리
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.sound, .badge, .list, .banner])
    }
}

// MARK: - MessagingDelegate (FCM 토큰 가져오기)
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else {
            print("❌ FCM 토큰을 가져오지 못했습니다.")
            return
        }

        do {
            try KeyChainManager.save(fcmToken, for: .apns)
        } catch {
            print("❌ FCM 토큰 저장 중 오류 발생: \(error.localizedDescription)")
        }

        print("✅ FCM 등록 토큰: \(fcmToken)")
    }
}
