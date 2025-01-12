//
//  Image+DesignSystem.swift
//  DesignSystem
//
//  Created by 박민서 on 1/12/25.
//  Copyright © 2025 yapp25-app2team. All rights reserved.
//

import SwiftUI

extension DesignSystemImages {
    var imageResource: ImageResource {
        ImageResource(name: self.name, bundle: .module)
    }
}

// MARK: Icon
public extension ImageResource {
    static let icnArrowDown: ImageResource = DesignSystemImages.icnArrowDown.imageResource
    static let icnArrowLeft: ImageResource = DesignSystemImages.icnArrowLeft.imageResource
    static let icnDelete: ImageResource = DesignSystemImages.icnDelete.imageResource
    static let icnDropDown: ImageResource = DesignSystemImages.icnDropDown.imageResource
    static let icnFeedback: ImageResource = DesignSystemImages.icnFeedback.imageResource
    static let icnFeedbackFilled: ImageResource = DesignSystemImages.icnFeedbackFilled.imageResource
    static let icnHome: ImageResource = DesignSystemImages.icnHome.imageResource
    static let icnHomeFilled: ImageResource = DesignSystemImages.icnHomeFilled.imageResource
    static let icnList: ImageResource = DesignSystemImages.icnList.imageResource
    static let icnListFilled: ImageResource = DesignSystemImages.icnListFilled.imageResource
    static let icnMypage: ImageResource = DesignSystemImages.icnMypage.imageResource
    static let icnMypageFilled: ImageResource = DesignSystemImages.icnMypageFilled.imageResource
    static let icnWrite: ImageResource = DesignSystemImages.icnWrite.imageResource
}
// MARK: Image
