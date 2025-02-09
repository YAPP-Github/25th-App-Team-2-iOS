//
//  OverlayContainer.swift
//  Presentation
//
//  Created by 박민서 on 2/9/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

import DesignSystem

public struct OverlayContainer: View {
    @EnvironmentObject var overlayManager: OverlayManager
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // ProgressView 표시 (화면 중앙)
            if overlayManager.isProgressVisible {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .red500))
                    .scaleEffect(1.5)
            }
            
            // 토스트 표시용 (하단에 표시)
            if let toast = overlayManager.currentToast {
                Color.white.opacity(0.0000001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        overlayManager.dismissIfAllowed()
                    }
                
                TToastView(message: toast.message, leftViewType: toast.leftViewType)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .onTapGesture {
                        overlayManager.dismissIfAllowed()
                    }
            }
        }
        .animation(.easeInOut, value: overlayManager.currentToast)
    }
}
