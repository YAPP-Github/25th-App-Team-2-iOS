//
//  ContentView.swift
//  TnTAPP
//
//  Created by 박서연 on 1/4/25.
//  Copyright © 2025 yapp25-app2team. All rights reserved.
//

import SwiftUI

import Presentation

struct ContentView: View {
    var body: some View {
        UserTypeSelectionView(store: .init(initialState: UserTypeSelectionFeature.State(), reducer: {
            UserTypeSelectionFeature()
        }))
    }
    
//    private func encodeParameters(request: URLRequest, parameters: [String: Any], encoding: ParameterEncoding) throws -> URLRequest {
//        var request = request
//        switch encoding {
//        case .url:
//            let queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
//            var components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
//            components?.queryItems = queryItems
//            request.url = components?.url
//        case .json:
//            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        }
//        return request
//    }
//    
//    private func createMultipartBody(data: Data, fileName: String, mimeType: String, boundary: String) -> Data {
//        var body = Data()
//        body.append("--\(boundary)\r\n".data(using: .utf8)!)
//        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
//        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
//        body.append(data)
//        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
//        return body
//    }
}

#Preview {
    ContentView()
}
