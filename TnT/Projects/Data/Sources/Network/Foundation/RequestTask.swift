//
//  RequestTask.swift
//  Data
//
//  Created by 박민서 on 1/21/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// 2. 요청 방식 정의 (Query, Body, Multipart 지원)
enum RequestTask {
    case requestPlain
    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding)
    case requestJSONEncodable(encodable: Encodable)
    case uploadMultipart(data: Data, fileName: String, mimeType: String)
    
    /// ✅ URLRequest 변환 메서드 추가
    func configureURLRequest(_ request: URLRequest) throws -> URLRequest {
        var modifiedRequest = request
        
        switch self {
        case .requestPlain:
            break
        case .requestParameters(let parameters, let encoding):
            try encoding.encode(&modifiedRequest, with: parameters)
        case .requestJSONEncodable(let encodable):
            modifiedRequest.httpBody = try JSONEncoder().encode(encodable)
            modifiedRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        case .uploadMultipart(let data, let fileName, let mimeType):
            let boundary = "Boundary-\(UUID().uuidString)"
            modifiedRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            modifiedRequest.httpBody = createMultipartBody(data: data, fileName: fileName, mimeType: mimeType, boundary: boundary)
        }
        
        return modifiedRequest
    }
    
    private func createMultipartBody(data: Data, fileName: String, mimeType: String, boundary: String) -> Data {
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        body.append(boundaryPrefix.data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
}

/// 3. Parameter Encoding 정의
enum ParameterEncoding {
    case url
    case json
    
    /// ✅ URLRequest를 자동으로 설정하는 기능 추가
    func encode(_ request: inout URLRequest, with parameters: [String: Any]) throws {
        switch self {
        case .url:
            guard var urlComponents = URLComponents(url: request.url!, resolvingAgainstBaseURL: false) else {
                throw NetworkError.unknown(statusCode: nil, message: "Invalid URL")
            }
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            request.url = urlComponents.url
        case .json:
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
    }
}
