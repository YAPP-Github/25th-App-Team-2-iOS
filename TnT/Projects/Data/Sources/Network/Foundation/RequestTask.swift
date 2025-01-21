//
//  RequestTask.swift
//  Data
//
//  Created by 박민서 on 1/21/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import Foundation

/// API 요청 타입을 정의하는 Enum
enum RequestTask {
    /// 단순한 요청 (ex: GET /users)
    case requestPlain
    /// URL 쿼리 또는 JSON 바디 파라미터를 포함한 요청
    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding)
    /// Encodable 객체를 JSON으로 변환하여 요청
    case requestJSONEncodable(encodable: Encodable)
    /// Multipart 파일 업로드 요청
    case uploadMultipart(files: [MultipartFile], additionalFields: [String: String])
    
    /// URLRequest를 구성하는 메서드
    /// - Parameter request: 원본 `URLRequest`
    /// - Returns: 변환된 `URLRequest`
    /// - Throws: 파라미터 인코딩 실패 시 오류 발생
    func configureURLRequest(_ request: URLRequest) throws -> URLRequest {
        var modifiedRequest: URLRequest = request
        
        switch self {
        case .requestPlain:
            break
            
        case .requestParameters(let parameters, let encoding):
            modifiedRequest = try encoding.encode(modifiedRequest, with: parameters)
            
        case .requestJSONEncodable(let encodable):
            modifiedRequest.httpBody = try JSONEncoder().encode(encodable)
            modifiedRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
        case .uploadMultipart(let files, let additionalFields):
            let boundary: String = "Boundary-\(UUID().uuidString)"
            if modifiedRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                modifiedRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            }
            modifiedRequest.httpBody = createMultipartBody(files: files, additionalFields: additionalFields, boundary: boundary)
        }
        
        return modifiedRequest
    }
}

// MARK: Private Helper Methods
private extension RequestTask {
    
    /// Multipart 요청 본문을 생성하는 메서드
    /// - Parameters:
    ///   - files: 업로드할 파일 리스트
    ///   - additionalFields: 추가 필드 (ex: 텍스트 데이터)
    ///   - boundary: 멀티파트 경계를 구분하는 문자열
    /// - Returns: 멀티파트 데이터가 포함된 `Data`
    func createMultipartBody(
        files: [MultipartFile],
        additionalFields: [String: String] = [:],
        boundary: String
    ) -> Data {
        var body: Data = Data()
        // 추가 필드 (텍스트 데이터) 처리
        additionalFields.forEach { key, value in
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        
        // 파일 데이터 처리
        files.forEach { file in
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(file.fieldName)\"; filename=\"\(file.fileName)\"\r\n")
            body.append("Content-Type: \(file.mimeType)\r\n\r\n")
            body.append(file.data)
            body.append("\r\n")
        }
        
        // 마지막 Boundary 추가
        body.append("--\(boundary)--\r\n")
        return body
    }
}
