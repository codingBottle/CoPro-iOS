//
//  LoginAPI.swift
//  CoPro
//
//  Created by 박현렬 on 2/13/24.
//

import Foundation
import Alamofire
import UIKit
import KeychainSwift

final class LoginAPI : BaseAPI {
    static let shared = LoginAPI()
    
    private override init() {}
}
extension LoginAPI {
    var baseURL: String { return Config.baseURL }
    // 로그인 API
    public func getAccessToken(authCode: String?, provider: String) {
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        // Body 설정
        let parameters: Parameters = [
            "authCode" : authCode!,
        ]
        AF.request("https://copro.shop/api/\(provider)/token", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300)
            .responseDecodable(of: LoginDTO.self) { response in
                switch response.result {
                case .success(let loginDTO):
                    print("\(provider) 로그인 성공")
                    print("AccessToken: \(loginDTO.data.accessToken)")
                    print("refreshToken: \(loginDTO.data.refreshToken)")
                    let keychain = KeychainSwift()
                    keychain.set(loginDTO.data.accessToken, forKey: "accessToken")
                    keychain.set(loginDTO.data.refreshToken, forKey: "refreshToken")
                    DispatchQueue.main.async {
                        let bottomTabController = BottomTabController()
                        // 현재 활성화된 UINavigationController의 루트 뷰 컨트롤러로 설정합니다.
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let delegate = windowScene.delegate as? SceneDelegate,
                           let window = delegate.window {
                            window.rootViewController = bottomTabController
                            window.makeKeyAndVisible()
                        }
                    }
                case .failure(_):
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 400...499:  // 클라이언트 에러
                            print("로그인 실패: 클라이언트 에러")
                        case 500...599:  // 서버 에러
                            print("로그인 실패: 서버 에러")
                        default:
                            print("로그인 실패: 알 수 없는 에러")
                        }
                    }
                    
                }
            }
        
    }
    public func refreshAccessToken(completion: @escaping (Result<LoginDTO, Error>) -> Void){
        let keychain = KeychainSwift()
        guard let refreshToken = keychain.get("refreshToken") else {
            print("No refreshToken found in keychain.")
            return
        }
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        // Body 설정
        let parameters: Parameters = [
            "refreshToken" : refreshToken,
        ]
        AF.request("https://copro.shop/api/token/access", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300)
            .responseDecodable(of: LoginDTO.self) { response in
                switch response.result {
                case .success(let loginDTO):
                    print("재발급 로그인 성공")
                    print("AccessToken: \(loginDTO.data.accessToken)")
                    print("refreshToken: \(loginDTO.data.refreshToken)")
                    let keychain = KeychainSwift()
                    keychain.set(loginDTO.data.accessToken, forKey: "accessToken")
                    keychain.set(loginDTO.data.refreshToken, forKey: "refreshToken")
                    completion(.success(loginDTO))
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 400...499:  // 클라이언트 에러
                            print("로그인 실패: 클라이언트 에러")
                        case 500...599:  // 서버 에러
                            print("로그인 실패: 서버 에러")
                        default:
                            print("로그인 실패: 알 수 없는 에러")
                        }
                    }
                    completion(.failure(error))
                }
            }
    }
}

