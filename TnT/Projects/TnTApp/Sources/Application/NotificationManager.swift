//
//  NotificationManager.swift
//  TnTApp
//
//  Created by 박서연 on 2/11/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationManager {
    static let shared: NotificationManager = NotificationManager()

    func checkNotificationPermission() {
        let center: UNUserNotificationCenter = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .notDetermined:
                    print("알림 권한이 결정되지 않았습니다. 요청합니다.")
                    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                        if granted {
                            print("✅ 알림 권한이 허용되었습니다")
                            DispatchQueue.main.async {
                                // 권한이 허용되면 APNs 등록
                                UIApplication.shared.registerForRemoteNotifications()
                            }
                        } else {
                            print("❌ 알림 권한이 거부되었습니다.")
                        }
                    }
                case .denied:
                    print("❌ 알림 권한이 거부되었습니다.")
                case .authorized, .provisional, .ephemeral:
                    print("✅ 알림 권한이 이미 허용되었습니다")
                    DispatchQueue.main.async {
                        // 이미 허용된 경우에도 APNs 등록
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                @unknown default:
                    print("⚠️ 알 수 없는 알림 권한 상태")
                }
            }
        }
    }
}
