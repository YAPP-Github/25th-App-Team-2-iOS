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
    static let icnArrowDown: ImageResource = DesignSystemAsset.icnArrowDown.imageResource
    static let icnArrowLeft: ImageResource = DesignSystemAsset.icnArrowLeft.imageResource
    static let icnDelete: ImageResource = DesignSystemAsset.icnDelete.imageResource
    static let icnDropDown: ImageResource = DesignSystemAsset.icnDropDown.imageResource
    static let icnFeedbackEmpty: ImageResource = DesignSystemAsset.icnFeedbackEmpty.imageResource
    static let icnFeedbackFilled: ImageResource = DesignSystemAsset.icnFeedbackFilled.imageResource
    static let icnHomeEmpty: ImageResource = DesignSystemAsset.icnHomeEmpty.imageResource
    static let icnHomeFilled: ImageResource = DesignSystemAsset.icnHomeFilled.imageResource
    static let icnListEmpty: ImageResource = DesignSystemAsset.icnListEmpty.imageResource
    static let icnListFilled: ImageResource = DesignSystemAsset.icnListFilled.imageResource
    static let icnMypageEmpty: ImageResource = DesignSystemAsset.icnMypageEmpty.imageResource
    static let icnMypageFilled: ImageResource = DesignSystemAsset.icnMypageFilled.imageResource
    static let icnWriteWhite: ImageResource = DesignSystemAsset.icnWriteWhite.imageResource
    static let icnWriteBlack: ImageResource = DesignSystemAsset.icnWriteBlack.imageResource
    static let icnRadioButtonUnselected: ImageResource = DesignSystemAsset.icnRadioButtonUnselected.imageResource
    static let icnRadioButtonSelected: ImageResource = DesignSystemAsset.icnRadioButtonSelected.imageResource
    static let icnCheckMarkEmpty: ImageResource = DesignSystemAsset.icnCheckMarkEmpty.imageResource
    static let icnCheckMarkFilled: ImageResource = DesignSystemAsset.icnCheckMarkFilled.imageResource
    static let icnCheckButtonUnselected: ImageResource = DesignSystemAsset.icnCheckButtonUnselected.imageResource
    static let icnCheckButtonSelected: ImageResource = DesignSystemAsset.icnCheckButtonSelected.imageResource
    static let icnStarEmpty: ImageResource = DesignSystemAsset.icnStarEmpty.imageResource
    static let icnStarFilled: ImageResource = DesignSystemAsset.icnStarFilled.imageResource
    static let icnHeartEmpty: ImageResource = DesignSystemAsset.icnHeartEmpty.imageResource
    static let icnHeartFilled: ImageResource = DesignSystemAsset.icnHeartFilled.imageResource
}

// MARK: Image
public extension ImageResource {
    static let imgAppSplash: ImageResource = DesignSystemAsset.imgAppSplash.imageResource
    static let imgDefaultProfileImage: ImageResource = DesignSystemAsset.imgDefaultProfileImage.imageResource
    static let imgOnboardingLogin: ImageResource = DesignSystemAsset.imgOnboardingLogin.imageResource
    static let imgOnboardingTrainee: ImageResource = DesignSystemAsset.imgOnboardingTrainee.imageResource
    static let imgOnboardingTrainer: ImageResource = DesignSystemAsset.imgOnboardingTrainer.imageResource
}
