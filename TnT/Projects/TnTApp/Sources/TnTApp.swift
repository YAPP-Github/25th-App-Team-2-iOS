//
//  TnTApp.swift
//  TnT
//
//  Created by 박서연 on 1/4/25.
//  Copyright © 2025 yapp25-app2team. All rights reserved.
//

import SwiftUI

import Presentation
import ComposableArchitecture
import DesignSystem

@main
struct ToyProjectApp: App {
    
    init() {
        DesignSystemFontFamily.registerAllCustomFonts()
    }

    var body: some Scene {
        WindowGroup {
            OnboardingView(store: Store(initialState: OnboardingFeature.State(), reducer: {
                OnboardingFeature()
            }))
//            ContentView()
        }
    }
}
