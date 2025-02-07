//
//  TPickerColumn.swift
//  DesignSystem
//
//  Created by 박민서 on 2/6/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import SwiftUI

/// 주어진 문자열 배열(items)을 반복하여 무한 스크롤을 표시하거나, 그대로 표시하는 열 뷰
struct FlatPickerColumn: View {
    /// 원본 배열
    let items: [String]
    /// 각 행의 높이
    let rowHeight: CGFloat
    /// 한 화면에 보일 행의 수 (중앙 행이 선택됨)
    let visibleCount: Int
    /// 일반 텍스트 폰트
    let normalFont: Font
    /// 중앙(선택) 텍스트 폰트
    let selectedFont: Font
    /// 일반 텍스트 색상
    let normalColor: Color
    /// 중앙(선택) 텍스트 색상
    let selectedColor: Color
    /// 무한 스크롤 여부: true이면 원본 데이터를 반복하여 보여줌, false이면 원본 배열 그대로 표시
    let infiniteScroll: Bool
    
    /// 반복 횟수 (무한 스크롤일 때만 사용)
    let repetition: Int = 100
    var totalCount: Int { infiniteScroll ? items.count * repetition : items.count }
    
    /// 원본 배열의 선택된 인덱스 (예: 0 ~ items.count-1)
    @Binding var selected: Int
    
    // 스크롤 스냅 예약 작업 관리
    @State private var pendingScrollTask: DispatchWorkItem? = nil
    
    var body: some View {
        GeometryReader { geo in
            let containerCenterY = geo.size.height / 2
            ScrollViewReader { scrollProxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(0..<totalCount, id: \.self) { index in
                            let value = items[index % items.count]
                            Text(value)
                                .frame(height: rowHeight)
                                .frame(maxWidth: .infinity)
                                .font((index % items.count) == selected ? selectedFont : normalFont)
                                .foregroundColor((index % items.count) == selected ? selectedColor : normalColor)
                                .id(index) // 스크롤 시 특정 인덱스로 이동하기 위함
                                .background(
                                    GeometryReader { rowGeo in
                                        Color.clear
                                            .preference(
                                                key: RowPreferenceKey.self,
                                                value: [RowPreferenceData(index: index, midY: rowGeo.frame(in: .named("scroll")).midY)]
                                            )
                                    }
                                )
                        }
                    }
                    // 위/아래 패딩 추가: 중앙에 한 행이 오도록 함
                    .padding(.vertical, (geo.size.height - rowHeight) / 2)
                }
                .coordinateSpace(name: "scroll")
                // PreferenceKey 업데이트를 통해 현재 중앙에 가장 가까운 행을 찾고 스냅 예약
                .onPreferenceChange(RowPreferenceKey.self) { values in
                    if let nearest = values.min(by: { abs($0.midY - containerCenterY) < abs($1.midY - containerCenterY) }) {
                        let newSelection = nearest.index % items.count
                        if newSelection != selected {
                            DispatchQueue.main.async {
                                selected = newSelection
                            }
                        }
                        
                        pendingScrollTask?.cancel()
                        
                        let targetIndex: Int
                        if infiniteScroll {
                            // 무한 스크롤인 경우: 현재 중앙 인덱스(currentIndex)를 기준으로 후보 계산
                            let currentIndex = nearest.index
                            let blockStart = currentIndex - (currentIndex % items.count)
                            var candidate = blockStart + newSelection
                            if candidate - currentIndex > items.count / 2 {
                                candidate -= items.count
                            } else if currentIndex - candidate > items.count / 2 {
                                candidate += items.count
                            }
                            targetIndex = candidate
                        } else {
                            // 유한 스크롤인 경우: 그냥 newSelection (0 ~ items.count-1)
                            targetIndex = newSelection
                        }
                        
                        let task = DispatchWorkItem {
                            withAnimation {
                                scrollProxy.scrollTo(targetIndex, anchor: .center)
                            }
                        }
                        pendingScrollTask = task
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: task)
                    }
                }
                .onAppear {
                    let initialIndex: Int
                    if infiniteScroll {
                        // 중앙 블록의 시작점: totalCount / 2를 items.count로 나눈 나머지를 제거한 값
                        let midBlock = (totalCount / 2) - ((totalCount / 2) % items.count)
                        // 그 중앙 블록에서 selected 값만큼 오프셋 적용
                        initialIndex = midBlock + selected
                    } else {
                        // 유한 스크롤일 경우, 선택값에 맞춰 중앙에 오도록
                        initialIndex = selected
                    }
                    DispatchQueue.main.async {
                        scrollProxy.scrollTo(initialIndex, anchor: .center)
                    }
                }
            }
        }
        .frame(height: rowHeight * CGFloat(visibleCount))
    }
}
