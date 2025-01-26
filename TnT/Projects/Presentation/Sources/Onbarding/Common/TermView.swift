//
//  TermView.swift
//  Presentation
//
//  Created by 박서연 on 1/24/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import DesignSystem

@ViewAction(for: TermFeature.self)
struct TermView: View {
    
    public let store: StoreOf<TermFeature>
    
    public init(store: StoreOf<TermFeature>) {
        self.store = store
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 0) {
                Header()
                term()
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            TBottomButton(title: "다음", isEnable: store.view_isAllAgreed) {
                send(.nextButtonTapped)
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    @ViewBuilder
    private func Header() -> some View {
        Text("약관에 동의해주세요")
            .typographyStyle(.heading3, with: .neutral900)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 20)
        
        Text("여러분의 개인정보와 서비스 이용 권리\n잘 지켜드릴게요")
            .typographyStyle(.body2Medium, with: .neutral500)
            .frame(maxWidth: .infinity, alignment: .leading)
        
        Spacer().frame(height: 40)
    }
    
    @ViewBuilder
    private func term() -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(store.view_isAllAgreed ? .icnCheckButtonSelected : .icnCheckButtonUnselected)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .onTapGesture {
                        send(.toggleAll(!store.view_isAllAgreed))
                    }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("모두 동의")
                        .typographyStyle(.body2Bold, with: .neutral900)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("서비스 이용을 위해 아래 약관에 모두 동의합니다.")
                        .typographyStyle(.body2Medium, with: .neutral500)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            TDivider(height: 2, color: .neutral100)
                .padding(.vertical, 8)
            
            ForEach(store.view_terms.keys.sorted(by: { $0.id < $1.id }), id: \.self) { term in
                termListItem(
                    term: term,
                    isAgreed: store.view_terms[term] ?? false
                ) {
                    send(.toggleTerm(term, $0))
                }
            }
        }
    }
    
    @ViewBuilder
    private func termListItem(term: Term, isAgreed: Bool, toggle: @escaping (Bool) -> Void) -> some View {
        HStack(spacing: 8) {
            Image(isAgreed ? .icnCheckButtonSelected : .icnCheckButtonUnselected)
                .resizable()
                .frame(width: 24, height: 24)
                .onTapGesture {
                    toggle(isAgreed)
                }
            
            Text(term.title)
                .typographyStyle(.body2Medium, with: .neutral500)
            
            Spacer()
            
            Text("보기")
                .typographyStyle(.body2Medium, with: .neutral300)
                .onTapGesture {
                    if let url = URL(string: term.url) {
                        UIApplication.shared.open(url)
                    }
                }
        }
    }
}
