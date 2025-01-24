//
//  TermView.swift
//  Presentation
//
//  Created by 박서연 on 1/24/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

@Reducer
public struct TermFeature {
    @ObservableState
    public struct State: Equatable {
        var terms: [Term: Bool]
        var isAllAgreed: Bool {
            terms.values.allSatisfy { $0 }
        }
        var viewState: ViewState
        
        public init(viewState: ViewState) {
            self.terms = [
                .term: false,
                .personalInfo: false
            ]
            self.viewState = viewState
        }
    }
    
    public struct ViewState: Equatable {
        public var isNavigating: Bool
        
        public init(isNavigating: Bool = false) {
            self.isNavigating = isNavigating
        }
    }
    
    public enum Action: Equatable {
        case toggleTerm(Term, Bool)
        case toggleAll(Bool)
        case setNavigating(Bool)
        case view(ViewAction)
        
        public enum ViewAction {
            case nextButtonTapped
        }
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .toggleTerm(let term, let isAgreed):
                state.terms[term] = isAgreed
                return .none
                
            case .toggleAll(let isAgreed):
                state.terms.keys.forEach { state.terms[$0] = isAgreed }
                return .none
                
            case .view(let action):
                switch action {
                case .nextButtonTapped:
                    print("next")
                    return .send(.setNavigating(true))
                }
            case .setNavigating(let isNavigating):
                state.viewState.isNavigating = isNavigating
                return .none
            }
        }
    }
}

struct TermView: View {
    
    public let store: StoreOf<TermFeature>
    
    public init(store: StoreOf<TermFeature>) {
        self.store = store
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("약관에 동의해주세요")
                    .typographyStyle(.heading3, with: .neutral900)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 20)
                
                Text("여러분의 개인정보와 서비스 이용 권리\n잘 지켜드릴게요")
                    .typographyStyle(.body2Medium, with: .neutral500)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer().frame(height: 40)
                
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        Image(store.isAllAgreed ? .icnCheckButtonSelected : .icnCheckButtonUnselected)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .onTapGesture {
                                store.send(.toggleAll(!store.isAllAgreed))
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
                    
                    ForEach(store.terms.keys.sorted(by: { $0.id < $1.id }), id: \.self) { term in
                        termsView(
                            term: term,
                            isAgreed: store.terms[term] ?? false
                        ) {
                            store.send(.toggleTerm(term, !$0))
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            TBottomButton(title: "다음", state: store.isAllAgreed ? .true : .false) {
                store.send(.view(.nextButtonTapped))
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    @ViewBuilder
    private func termsView(term: Term, isAgreed: Bool, toggle: @escaping (Bool) -> Void) -> some View {
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

public enum Term: CaseIterable {
    case term
    case personalInfo
    
    var id: Int {
        switch self {
        case .term:
            return 0
        case .personalInfo:
            return 1
        }
    }
    
    var title: String {
        switch self {
        case .term:
            return "(필수)서비스 이용약관 동의"
        case .personalInfo:
            return "(필수)개인정보 처리방침 동의"
        }
    }
    
    var url: String {
        switch self {
        case .term:
            return ""
        case .personalInfo:
            return ""
        }
    }
}
