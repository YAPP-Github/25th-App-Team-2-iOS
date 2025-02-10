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
    static let shared = NotificationManager()
    
    private init() {}

    func checkNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                print("알림 권한이 허용되었습니다.")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            case .denied:
                print("알림 권한이 거부되었습니다. 설정에서 변경해주세요.")
            case .notDetermined:
                print("알림 권한이 결정되지 않았습니다. 요청합니다.")
                self.requestNotificationPermission()
            @unknown default:
                print("알림 권한 상태를 확인할 수 없습니다.")
            }
        }
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("알림 권한 요청 중 오류 발생: \(error.localizedDescription)")
                return
            }

            if granted {
                print("알림 권한이 허용되었습니다.")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("알림 권한이 거부되었습니다.")
            }
        }
    }
}
