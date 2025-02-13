//
//  GestureNavigation.swift
//  Presentation
//
//  Created by 박서연 on 2/13/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
  open override func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = self
  }
  
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 2
  }
}
