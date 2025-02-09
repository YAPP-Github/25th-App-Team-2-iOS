//
//  ToastManager.swift
//  Presentation
//
//  Created by 박민서 on 2/9/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

public final class OverlayManager: ObservableObject {
    public static let shared = OverlayManager()
    
    /// 현재 화면에 표시 중인 토스트 (없으면 nil)
    @Published var currentToast: Toast? = nil
    
    /// ProgressView 표시 여부
    @Published var isProgressVisible: Bool = false
    
    /// 대기중인 토스트 큐
    private var toastQueue: [Toast] = []
    /// 현재 토스트 자동 해제를 위한 작업 항목
    private var dismissWorkItem: DispatchWorkItem?
    
    private init() {
        initNotificationCenter()
    }
    
    /// 새로운 토스트를 요청합니다.
    /// - 현재 토스트가 표시 중이면 큐에 추가(순차적으로 표시)
    /// - 현재 토스트가 없으면 바로 표시
    func showToast(_ newToast: Toast) {
        if currentToast != nil {
            toastQueue.append(newToast)
        } else {
            presentToast(newToast)
        }
    }
    
    /// 현재 표시 중인 토스트를 애니메이션과 함께 해제한 후, 대기 큐에 있는 다음 토스트를 표시합니다.
    func dismissCurrentToast() {
        withAnimation {
            currentToast = nil
        }
        // 자동 해제 작업 취소
        dismissWorkItem?.cancel()
        dismissWorkItem = nil
        
        // 애니메이션이 끝날(약 0.3초 후) 때 다음 토스트 표시
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.showNextToast()
        }
    }
    
    /// 배경 탭 등으로 현재 토스트를 해제할 때 호출합니다.
    /// 단, 현재 토스트가 dismissibleOnTap이 true인 경우에만 해제합니다.
    func dismissIfAllowed() {
        if let toast = currentToast, toast.dismissibleOnTap {
            dismissCurrentToast()
        }
    }
    
    /// 필요 시 큐에 있는 모든 토스트와 현재 토스트를 해제합니다.
    func dismissAllToasts() {
        toastQueue.removeAll()
        dismissCurrentToast()
    }
}

// MARK: Internal Logic
extension OverlayManager {
    /// 토스트를 표시하고, 지정된 시간 후 자동 해제 스케줄을 등록합니다.
    private func presentToast(_ toast: Toast) {
        withAnimation {
            currentToast = toast
        }
        
        // 이전 자동 해제 작업 취소
        dismissWorkItem?.cancel()
        // 자동 해제를 위한 작업 생성
        let workItem = DispatchWorkItem { [weak self] in
            self?.dismissCurrentToast()
        }
        dismissWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: workItem)
    }
    
    /// 큐에서 표시 대기 중인 다음 토스트를 출력합니다
    private func showNextToast() {
        if !toastQueue.isEmpty {
            let nextToast = toastQueue.removeFirst()
            presentToast(nextToast)
        }
    }
}

// MARK: NotificationCenter
extension OverlayManager {
    private func initNotificationCenter() {
        let nc = NotificationCenter.default
        // 토스트 노티 옵저버
        nc.addObserver(
            self,
            selector: #selector(handleShowToastNotification(_:)),
            name: .showToastNotification,
            object: nil
        )
        // 토스트 삭제 노티 옵저버
            nc.addObserver(
                self,
                selector: #selector(handleDeleteToastNotification(_:)),
                name: .deleteToastNotification,
                object: nil
            )
        // ProgressView 표시 노티 옵저버
        nc.addObserver(
            self,
            selector: #selector(handleShowProgressNotification(_:)),
            name: .showProgressNotification,
            object: nil
        )
        // ProgressView 숨기기 노티 옵저버
        nc.addObserver(
            self,
            selector: #selector(handleHideProgressNotification(_:)),
            name: .hideProgressNotification,
            object: nil
        )
    }
    
    @objc private func handleShowToastNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let toast = userInfo["toast"] as? Toast else { return }
        self.showToast(toast)
    }
    
    @objc private func handleDeleteToastNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let toastToDelete = userInfo["toast"] as? Toast else { return }
        
        DispatchQueue.main.async {
            withAnimation {
                // 현재 표시 중인 토스트가 삭제 대상인지 확인
                if let current = self.currentToast, current.id == toastToDelete.id {
                    self.dismissCurrentToast()
                } else {
                    // 대기 큐에서 동일 id의 토스트 삭제
                    self.toastQueue.removeAll { $0.id == toastToDelete.id }
                }
            }
        }
    }
    
    @objc private func handleShowProgressNotification(_ notification: Notification) {
        DispatchQueue.main.async {
            withAnimation {
                self.isProgressVisible = true
            }
        }
    }
    
    @objc private func handleHideProgressNotification(_ notification: Notification) {
        DispatchQueue.main.async {
            withAnimation {
                self.isProgressVisible = false
            }
        }
    }
}
