//
//  LoginAPI.swift
//  CoPro
//
//  Created by 박현렬 on 2/13/24.
//

import Foundation
import Alamofire

final class LoginAPI : BaseAPI {
    static let shared = LoginAPI()
    
    private override init() {}
}
extension LoginAPI {
    var baseURL: String { return Config.baseURL }
    // 로그인 API
    public func getAccessToken(authCode: String?, provider: String, completion: @escaping (Result<LoginDTO, AFError>) -> Void) {
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        // Body 설정
        let parameters: Parameters = [
            "authCode" : authCode!,
        ]
        AF.request("\(baseURL)/api/\(provider)/token", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: LoginDTO.self) { response in
                switch response.result {
                case .success(let loginDTO):
                    // 성공 시의 처리
                    completion(.success(loginDTO))
                case .failure(let error):
                    // 실패 시의 처리
                    print("Decoding error: \(error)")
                    completion(.failure(error))
                }
            }

    }
}

