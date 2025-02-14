//
//  Debouncer.swift
//  Presentation
//
//  Created by 박민서 on 2/14/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

struct DebounceModifier: ViewModifier {
    let delay: TimeInterval
    @State private var isDisabled = false
    
    func body(content: Content) -> some View {
        content
            .disabled(isDisabled)
            .onTapGesture {
                guard !isDisabled else { return }
                isDisabled = true
                Task {
                    try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    isDisabled = false
                }
            }
    }
}

/// Debounce를 적용하는 모디파이어 입니다 기본 1초 적용
extension View {
    func debounce(for delay: TimeInterval = 1.0) -> some View {
        self.modifier(DebounceModifier(delay: delay))
    }
}
