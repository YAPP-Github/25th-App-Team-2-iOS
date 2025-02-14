//
//  BottomViewFixer.swift
//  Presentation
//
//  Created by 박민서 on 2/14/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

struct BottomViewFixModifier<BottomView: View>: ViewModifier {
    let bottomView: BottomView
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            VStack {
                Spacer()
                bottomView
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}

extension View {
    func bottomFixWith<BottomView: View>(@ViewBuilder view: () -> BottomView) -> some View {
        self.modifier(BottomViewFixModifier(bottomView: view()))
    }
}
