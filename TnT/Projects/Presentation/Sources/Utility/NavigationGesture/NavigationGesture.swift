//
//  NavigationGesture.swift
//  Presentation
//
//  Created by 박서연 on 2/13/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    static var gestureEnabled: Bool = true
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 2 && UINavigationController.gestureEnabled
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        sequence(first: self) {
            $0.next
        }.first { $0 is UIViewController } as? UIViewController
    }
}

struct PopGestureModifier: ViewModifier {
    let disabled: Bool
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                UINavigationController.gestureEnabled = !disabled
            }
            .onDisappear {
                UINavigationController.gestureEnabled = true
            }
    }
}

extension View {
    /// 뷰가 실제 화면에 보일 때만 pop 제스처가 비활성화되고, 화면에서 사라지면 자동으로 제스처가 다시 활성화됩니다.
    func navigationPopGestureDisabled(_ disabled: Bool = true) -> some View {
        self.modifier(PopGestureModifier(disabled: disabled))
    }
}
