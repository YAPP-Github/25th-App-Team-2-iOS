//
//  Notification+.swift
//  Presentation
//
//  Created by 박민서 on 2/9/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

public extension Notification.Name {
    /// 토스트를 표시하기 위한 노티피케이션 이름
    static let showToastNotification = Notification.Name("ShowToastNotification")
    /// 토스트를 삭제하기 위한 노티피케이션 이름
    static let deleteToastNotification = Notification.Name("DeleteToastNotification")
    /// ProgressView를 표시하기 위한 노티피케이션 이름
    static let showProgressNotification = Notification.Name("ShowProgressNotification")
    /// ProgressView를 숨기기 위한 노티피케이션 이름
    static let hideProgressNotification = Notification.Name("HideProgressNotification")
    /// 세션 만료 팝업을 표시하기 위한 노티피케이션 이름
    static let showSessionExpiredPopupNotification = Notification.Name("ShowSessionExpiredPopupNotification")
    /// FCM 토큰 - 트레이너/트레이니 연결 완료 receive 노티피케이션 이름
    static let fcmUserConnectedNotification = Notification.Name("FCMUserConnectedNotification")
}

public extension NotificationCenter {
    /// 토스트를 보내는 편의 메서드
    func post(toast: Toast) {
        NotificationCenter.default.post(
            name: .showToastNotification,
            object: nil,
            userInfo: ["toast": toast]
        )
    }
    
    /// 토스트 삭제를 요청하는 편의 메서드
    func postDelete(toast: Toast) {
        NotificationCenter.default.post(
            name: .deleteToastNotification,
            object: nil,
            userInfo: ["toast": toast]
        )
    }
    
    /// ProgressView 표시 여부를 보내는 편의 메서드
    func postProgress(visible: Bool) {
        let name: Notification.Name = visible ? .showProgressNotification : .hideProgressNotification
        self.post(name: name, object: nil)
    }
    
    /// 세션 만료 팝업 표시를 요청하는 편의 메서드
    func postSessionExpired() {
        NotificationCenter.default.post(name: .showSessionExpiredPopupNotification, object: nil)
    }
}
