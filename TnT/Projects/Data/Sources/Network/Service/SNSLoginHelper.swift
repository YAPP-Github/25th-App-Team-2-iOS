//
//  SNSLoginHelper.swift
//  DomainAuthInterface
//
//  Created by 박민서 on 9/19/24.
//

import Foundation
import AuthenticationServices
import NaverThirdPartyLogin
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import Core
import SharedUtil
import DomainAuthInterface

/// SNSLoginHelper는 카카오, 네이버, 애플과 같은 소셜 로그인 및 로그아웃을 위한 헬퍼 클래스입니다.
/// 소셜 로그인 관련 SDK, API 호출은 모두 이곳에서 관리됩니다.
/// - 의존성:
///   - 카카오, 네이버, 애플 로그인 SDK와 직접 통신하여 API 요청을 처리합니다.
public final class SNSLoginHelper: NSObject, SNSLoginHelperProtocol {
    
    override public init() {
        KakaoSDK.initSDK(appKey: SecretConstants.kakaoLoginAPIKey)
    }
    
    // 클로저 저장을 위한 프로퍼티
    private var appleLoginCompletion: ((AppleLoginInfo?) -> Void)?
    private var naverLoginCompletion: ((NaverLoginInfo?) -> Void)?
    
    // 애플 로그인
    public func appleLogin() async -> AppleLoginInfo? {
        
        // 클로저 기반의 비동기 작업을 async/await 방식으로 변환
        await withCheckedContinuation { continuation in
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            
            self.appleLoginCompletion = { loginInfo in
                // 비동기 작업이 끝나면 continuation.resume()으로 결과를 넘깁니다
                continuation.resume(returning: loginInfo)  // 로그인 성공 또는 실패 후 반환
            }
            
            authorizationController.performRequests()
        }
    }
    
    // 네이버 로그인
    @MainActor
    public func naverLogin() async -> NaverLoginInfo? {
        await withCheckedContinuation { continuation in

            Task {
                // Main Actor에서 비동기적으로 네이버 로그인 처리
                let naverLoginConnection = NaverThirdPartyLoginConnection.getSharedInstance()
                // 네이버 토큰 존재하는 경우 초기화
                naverLoginConnection?.resetToken()
                // 네이버 앱으로 로그인 허용
                naverLoginConnection?.isNaverAppOauthEnable = true
                // 브라우저 로그인 허용
                naverLoginConnection?.isInAppOauthEnable = true
                // 네이버 로그인 세로모드 고정
                naverLoginConnection?.setOnlyPortraitSupportInIphone(true)
                // 네이버 UrlScheme 적용
                naverLoginConnection?.serviceUrlScheme = Bundle.main.bundleIdentifier
                // 네이버 키 작성
                naverLoginConnection?.consumerKey = SecretConstants.naverLoginConsumerKey
                naverLoginConnection?.consumerSecret = SecretConstants.naverLoginClinetSecret
                // 접속 앱 이름 작성
                naverLoginConnection?.appName = "나모"
                
                naverLoginConnection?.delegate = self
                naverLoginConnection?.requestThirdPartyLogin()
            }
            
            // 네이버 로그인 결과를 전달하는 방식
            self.naverLoginCompletion = { loginInfo in
                continuation.resume(returning: loginInfo)
            }
        }
    }
    
    // 카카오 로그인
    public func kakaoLogin() async -> KakaoLoginInfo? {
        return await loginWithKakao {
            // 카카오 앱의 설치 유무에 따라 로그인 처리
            return UserApi.isKakaoTalkLoginAvailable()
            ? await self.loginWithKakaoTalk()
            : await self.loginWithKakaoWeb()
        }
    }
    
    // 카카오 로그아웃
    public func kakaoLogout() async {
        if AuthApi.hasToken() {
            await withCheckedContinuation { continuation in
                UserApi.shared.logout() { error in
                    if let error {
                        print("Kakao Logout Failed: \(error.localizedDescription)")
                        continuation.resume()
                    }
                    else {
                        print("Kakao Logout Success")
                        continuation.resume()
                    }
                }
            }
        }
    }
    
    // 네이버 로그아웃
    public func naverLogout() async {
        await NaverThirdPartyLoginConnection.getSharedInstance().requestDeleteToken()
        print("Naver Logout Success")
    }
}

// MARK: 애플 로그인 Extension 구현
extension SNSLoginHelper: ASAuthorizationControllerDelegate, ASWebAuthenticationPresentationContextProviding, ASAuthorizationControllerPresentationContextProviding {
    
    // 애플 로그인 성공 시 필요 정보 클로저로 리턴
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            self.appleLoginCompletion?(nil)
            return
        }
        
        guard
            let identityToken = appleIDCredential.identityToken,
            let identityTokenString = String(data: identityToken, encoding: .utf8),
            let authorizationCode = appleIDCredential.authorizationCode,
            let authorizationCodeString = String(data: authorizationCode, encoding: .utf8)
        else {
            self.appleLoginCompletion?(nil)
            return
        }
        
        self.appleLoginCompletion?(
            AppleLoginInfo(
                identityToken: identityTokenString,
                authorizationCode: authorizationCodeString
            )
        )
    }
    
    // 애플 로그인 실패 시 nil 리턴
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple login failed: \(error.localizedDescription)")
        self.appleLoginCompletion?(nil)
    }
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
    
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
}

// MARK: 네이버 로그인 Extension 구현
extension SNSLoginHelper: NaverThirdPartyLoginConnectionDelegate {
    public func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        
        guard
            let naverAccessToken = NaverThirdPartyLoginConnection.getSharedInstance().accessToken,
            let naverRefreshToken = NaverThirdPartyLoginConnection.getSharedInstance().refreshToken
        else {
            self.naverLoginCompletion?(nil)
            return
        }
        
        self.naverLoginCompletion?(
            NaverLoginInfo(
                accessToken: naverAccessToken,
                socialRefreshToken: naverRefreshToken
            )
        )
    }
    
    public func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
    }
    
    public func oauth20ConnectionDidFinishDeleteToken() {
    }
    
    public func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: (any Error)!) {
        print("Naver login failed: \(error.localizedDescription)")
        self.naverLoginCompletion?(nil)
    }
}

// MARK: 카카오 로그인 Extension 구현
extension SNSLoginHelper {
    
    /// 카카오톡(App) 로그인 처리를 async await로 래핑하는 함수입니다
    @MainActor
    private func loginWithKakaoTalk() async -> (OAuthToken?, Error?) {
        return await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                continuation.resume(returning: (oauthToken, error))
            }
        }
    }
    
    /// 카카오톡(Web) 로그인 처리를 async await로 래핑하는 함수입니다
    @MainActor
    private func loginWithKakaoWeb() async -> (OAuthToken?, Error?) {
        return await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                continuation.resume(returning: (oauthToken, error))
            }
        }
    }
    
    /// 공통된 카카오 로그인 로직을 async/await 방식으로 처리
    /// - Parameters:
    ///   - loginMethod: 로그인 방식 (카카오톡 또는 웹 로그인을 선택적으로 처리)
    /// - Returns: 성공 시 `KakaoLoginInfo`를 반환하고, 실패(에러, 토큰x) 시 nil을 반환합니다.
    private func loginWithKakao(
        loginMethod: @escaping () async -> (OAuthToken?, Error?)
    ) async -> KakaoLoginInfo? {
        let (oauthToken, error) = await loginMethod()
        
        if let error = error {
            print("kakao login failed: \(error.localizedDescription)")
            return nil // 에러 발생 시 nil 반환
        }
        
        guard
            let kakaoAccessToken = oauthToken?.accessToken,
            let kakaoRefreshToken = oauthToken?.refreshToken
        else {
            return nil // 토큰이 없을 시 nil 반환
        }
        
        return KakaoLoginInfo(
            accessToken: kakaoAccessToken,
            socialRefreshToken: kakaoRefreshToken
        )
    }
}
