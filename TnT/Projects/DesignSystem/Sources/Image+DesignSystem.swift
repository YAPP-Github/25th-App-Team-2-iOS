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
    static let icnFeedbackEmpty: ImageResource = DesignSystemImages.icnFeedbackEmpty.imageResource
    static let icnFeedbackFilled: ImageResource = DesignSystemImages.icnFeedbackFilled.imageResource
    static let icnHomeEmpty: ImageResource = DesignSystemImages.icnHomeEmpty.imageResource
    static let icnHomeFilled: ImageResource = DesignSystemImages.icnHomeFilled.imageResource
    static let icnListEmpty: ImageResource = DesignSystemImages.icnListEmpty.imageResource
    static let icnListFilled: ImageResource = DesignSystemImages.icnListFilled.imageResource
    static let icnMypageEmpty: ImageResource = DesignSystemImages.icnMypageEmpty.imageResource
    static let icnMypageFilled: ImageResource = DesignSystemImages.icnMypageFilled.imageResource
    static let icnWriteWhite: ImageResource = DesignSystemImages.icnWriteWhite.imageResource
    static let icnWriteBlack: ImageResource = DesignSystemImages.icnWriteBlack.imageResource
    static let icnRadioButtonUnselected: ImageResource = DesignSystemImages.icnRadioButtonUnselected.imageResource
    static let icnRadioButtonSelected: ImageResource = DesignSystemImages.icnRadioButtonSelected.imageResource
    static let icnCheckMarkEmpty: ImageResource = DesignSystemImages.icnCheckMarkEmpty.imageResource
    static let icnCheckMarkFilled: ImageResource = DesignSystemImages.icnCheckMarkFilled.imageResource
    static let icnCheckButtonUnselected: ImageResource = DesignSystemImages.icnCheckButtonUnselected.imageResource
    static let icnCheckButtonSelected: ImageResource = DesignSystemImages.icnCheckButtonSelected.imageResource
    static let icnStarEmpty: ImageResource = DesignSystemImages.icnStarEmpty.imageResource
    static let icnStarFilled: ImageResource = DesignSystemImages.icnStarFilled.imageResource
    static let icnHeartEmpty: ImageResource = DesignSystemImages.icnHeartEmpty.imageResource
    static let icnHeartFilled: ImageResource = DesignSystemImages.icnHeartFilled.imageResource
}

// MARK: Image
public extension ImageResource {
    static let imgAppSplash = DesignSystemImages.imgAppSplash.imageResource
    static let imgDefaultProfileImage = DesignSystemImages.imgDefaultProfileImage.imageResource
    static let imgOnboardingLogin = DesignSystemImages.imgOnboardingLogin.imageResource
    static let imgOnboardingTrainee = DesignSystemImages.imgOnboardingTrainee.imageResource
    static let imgOnboardingTrainer = DesignSystemImages.imgOnboardingTrainer.imageResource
}
