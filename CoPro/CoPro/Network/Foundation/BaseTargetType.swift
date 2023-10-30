//
//  BaseTargetType.swift
//  CoPro
//
//  Created by 문인호 on 10/30/23.
//

import Foundation

import Alamofire

protocol BaseTargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: RequestParams { get }
    var headers: HTTPHeaders? { get }
}

extension BaseTargetType {

    var baseURL: String {
        return Config.baseURL
    }
    
    var headers: HTTPHeaders? {
        nil
    }
    
    // URLRequestConvertible 구현
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        if let headers = self.headers {
                   for header in headers {
                       urlRequest.setValue(header.value, forHTTPHeaderField: header.name)
                   }
               }
        urlRequest.setValue(APIConstants.applicationJSON, forHTTPHeaderField: APIConstants.contentType)
        
        switch parameters {
        case .query(let request):
            let params = request?.toDictionary() ?? [:]
            let queryParams = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
        case .body(let request):
            let encoder = JSONEncoder()
            if let requestData = request {
                do {
                    let jsonData = try encoder.encode(requestData)
                    urlRequest.httpBody = jsonData
                } catch {
                    throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
                }
            }
        case .both(let query, let body):
            let params = query?.toDictionary() ?? [:]
            let queryParams = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
            let body = body?.toDictionary() ?? [:]
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        case .none:
            break
        }
        return urlRequest
    }
}

enum RequestParams {
    case query(_ parameter: Encodable?)
    case body(_ parameter: Encodable?)
    case both(_ parameter: Encodable?, _parameter: Encodable?)
    case none
}

extension Encodable {
    func toDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
              let jsonData = try? JSONSerialization.jsonObject(with: data),
              let dictionaryData = jsonData as? [String: Any] else { return [:] }
        return dictionaryData
    }
}
