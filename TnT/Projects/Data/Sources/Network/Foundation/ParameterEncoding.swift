//
//  ParameterEncoding.swift
//  Data
//
//  Created by 박민서 on 1/22/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// HTTP 요청의 파라미터 인코딩 방식 정의
enum ParameterEncoding {
    case url
    case json
    
    /// URLRequest에 파라미터를 인코딩하는 메서드
    /// - Parameters:
    ///   - request: 원본 `URLRequest`
    ///   - parameters: 인코딩할 파라미터 `[String: Any]`
    /// - Returns: 변환된 `URLRequest`
    /// - Throws: URL 변환 실패 또는 JSON 인코딩 실패 시 오류 발생
    func encode(_ request: URLRequest, with parameters: [String: Any]) throws -> URLRequest {
        var modifiedRequest: URLRequest = request
        
        switch self {
        case .url:
            guard let url = request.url, var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                throw NetworkError.unknown(statusCode: nil, message: "Invalid URL")
            }
            
            urlComponents.queryItems = parameters.map { key, value in
                let stringValue: String = (value as? CustomStringConvertible)?.description ?? "\(value)"
                return URLQueryItem(name: key, value: stringValue)
            }
            
            guard let finalURL = urlComponents.url else {
                throw NetworkError.unknown(statusCode: nil, message: "Failed to construct final URL")
            }
            
            modifiedRequest.url = finalURL
            
        case .json:
            modifiedRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            if modifiedRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                modifiedRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }
        
        return modifiedRequest
    }
}
