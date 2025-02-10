//
//  ToastPresentType.swift
//  Presentation
//
//  Created by 박민서 on 2/9/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

import Domain
import DesignSystem

extension Toast {
    var leftViewType: TToastView.LeftViewType {
        switch self.presentType {
        case .text(let string):
            return .text(string)
        case .image(let resource):
            return .image(resource)
        case .processing:
            return .processing
        case .none:
            return .none
        }
    }
}
