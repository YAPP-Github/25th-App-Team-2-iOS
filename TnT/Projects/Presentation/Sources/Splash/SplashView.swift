//
//  SplashView.swift
//  Presentation
//
//  Created by 박민서 on 2/10/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

import DesignSystem

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            Image(.imgAppSplash)
                .resizable()
                .scaledToFit()
                .frame(width: 156, height: 156)
        }
    }
}
