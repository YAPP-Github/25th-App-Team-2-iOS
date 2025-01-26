//
//  KeyboardDismiss.swift
//  Presentation
//
//  Created by 박민서 on 1/24/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// 화면을 탭하거나 드래그하면 키보드를 자동으로 내리는 Modifier입니다
struct KeyboardDismissModifier: ViewModifier {
    var dismissOnDrag: Bool = true

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.clear)
            .onTapGesture {
                dismissKeyboard()
            }
            .simultaneousGesture(
                dismissOnDrag ? DragGesture().onChanged { _ in dismissKeyboard() } : nil
            )
    }
    
    /// Modifier 내부에서 직접 키보드 내리는 함수
    private func dismissKeyboard() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        windowScene.windows.forEach { $0.endEditing(true) }
    }
}

/// `View`에 `.keyboardDismissOnTap()`을 추가할 수 있도록 Extension 
extension View {
    func keyboardDismissOnTap(dismissOnDrag: Bool = true) -> some View {
        self.modifier(KeyboardDismissModifier(dismissOnDrag: dismissOnDrag))
    }
}
