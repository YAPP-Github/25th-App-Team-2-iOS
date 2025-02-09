//
//  ToastManager.swift
//  Presentation
//
//  Created by 박민서 on 2/9/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

extension Notification.Name {
    /// 앱 어디서든 토스트를 표시하기 위한 노티피케이션 이름
    static let showToastNotification = Notification.Name("ShowToastNotification")
    /// 앱 어디서든 ProgressView를 표시하기 위한 노티피케이션 이름
        static let showProgressNotification = Notification.Name("ShowProgressNotification")
        /// ProgressView를 숨기기 위한 노티피케이션 이름
        static let hideProgressNotification = Notification.Name("HideProgressNotification")
}

extension NotificationCenter {
    /// 토스트를 보내는 편의 메서드
    func post(toast: Toast) {
        NotificationCenter.default.post(
            name: .showToastNotification,
            object: nil,
            userInfo: ["toast": toast]
        )
    }
    
    /// ProgressView 표시 여부를 보내는 편의 메서드
    func postProgress(visible: Bool) {
        let name: Notification.Name = visible ? .showProgressNotification : .hideProgressNotification
        self.post(name: name, object: nil)
    }
}

/// 개별 토스트 데이터 (좌측 뷰 타입, 메시지, 지속시간, 탭 시 해제 가능 여부)
public struct Toast: Identifiable, Equatable {
    public let id = UUID()
    public let leftViewType: TToastView.LeftViewType
    public let message: String
    public let duration: TimeInterval
    public let dismissibleOnTap: Bool

    public init(leftViewType: TToastView.LeftViewType,
                message: String,
                duration: TimeInterval = 2.0,
                dismissibleOnTap: Bool = true
    ) {
        self.leftViewType = leftViewType
        self.message = message
        self.duration = duration
        self.dismissibleOnTap = dismissibleOnTap
    }
}

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
        let nc = NotificationCenter.default
        // 토스트 노티 옵저버
        nc.addObserver(
            self,
            selector: #selector(handleShowToastNotification(_:)),
            name: .showToastNotification,
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
            // userInfo에서 Toast struct를 직접 받아옵니다.
            guard let userInfo = notification.userInfo,
                  let toast = userInfo["toast"] as? Toast else { return }
            self.showToast(toast)
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
    
    /// 새로운 토스트를 요청합니다.
    /// - Parameters:
    ///   - toast: 토스트 내용
    func showToast(_ newToast: Toast) {
        if currentToast != nil {
            // 현재 토스트가 표시 중이면 큐에 추가(순차적으로 표시)
            toastQueue.append(newToast)
        } else {
            // 현재 토스트가 없으면 바로 표시
            presentToast(newToast)
        }
    }
    
    /// 토스트를 표시하고, 지정된 시간 후 자동 해제 스케줄을 등록합니다.
    private func presentToast(_ toast: Toast) {
        withAnimation {
            currentToast = toast
        }
        
        // 이전 자동 해제 작업 취소
        dismissWorkItem?.cancel()
        // 지정 시간 후 자동 해제를 위한 작업 생성
        let workItem = DispatchWorkItem { [weak self] in
            self?.dismissCurrentToast()
        }
        dismissWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: workItem)
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
    
    private func showNextToast() {
        if !toastQueue.isEmpty {
            let nextToast = toastQueue.removeFirst()
            presentToast(nextToast)
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

import SwiftUI

import DesignSystem

public struct ToastContainer: View {
    @EnvironmentObject var toastManager: OverlayManager
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // 토스트 표시용 (하단에 표시)
            if let toast = toastManager.currentToast {
                Color.white.opacity(0.0000001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        toastManager.dismissIfAllowed()
                    }
                
                TToastView(message: toast.message, leftViewType: toast.leftViewType)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .onTapGesture {
                        toastManager.dismissIfAllowed()
                    }
            }
            
            // ProgressView 표시 (화면 중앙)
            if toastManager.isProgressVisible {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .red500))
                    .scaleEffect(1.5)
            }
        }
        .animation(.easeInOut, value: toastManager.currentToast)
    }
}
