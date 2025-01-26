//
//  Config.swift
//  Data
//
//  Created by 박민서 on 1/25/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// Network 모듈에서 사용되는 환경 변수(Config)들을 관리하는 구조체
/// - Info.plist에 설정된 값을 가져와 활용
struct Config {
    /// 개발 서버의 API Base URL
    static let apiBaseUrlDev: String = {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL_DEV") as? String else {
            fatalError("🚨 API_BASE_URL_DEV가 Info.plist에서 설정되지 않았습니다!")
        }
        return url
    }()
    
    /// 카카오 로그인에 사용되는 네이티브 앱 키
    static let kakaoNativeAppKey: String = {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY") as? String else {
            fatalError("🚨 KAKAO_NATIVE_APP_KEY가 Info.plist에서 설정되지 않았습니다!")
        }
        return url
    }()
}
