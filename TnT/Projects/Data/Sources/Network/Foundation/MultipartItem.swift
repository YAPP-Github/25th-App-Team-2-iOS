//
//  MultipartItem.swift
//  Data
//
//  Created by 박민서 on 1/22/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 멀티파트 업로드 파일을 정의하는 구조체
struct MultipartFile {
    /// API 요청에서 사용할 필드명
    let fieldName: String
    /// 업로드할 파일명
    let fileName: String
    /// 파일의 MIME 타입
    let mimeType: String
    /// 파일 데이터
    let data: Data
}
