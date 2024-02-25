//
//  NotificationListAPI.swift
//  CoPro
//
//  Created by 박현렬 on 2/22/24.
//

import Foundation
import Alamofire
import KeychainSwift
final class NotificationListAPI : BaseAPI {
    static let shared = NotificationListAPI()
    
    private override init() {}
}
extension NotificationListAPI {
    var baseURL: String { return Config.baseURL }
    func getNotificationListData(page: Int,completion: @escaping (Result<NotificationListDTO, AFError>) -> Void){
        //keychain 토큰가저오기
        let keychain = KeychainSwift()
        guard let token = keychain.get("accessToken") else {
            print("No token found in keychain.")
            return
        }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        let parameters: Parameters = [
            "page":page,
            "size":10
            
        ]
        AF.request("\(baseURL)/api/notifications", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .responseDecodable(of: NotificationListDTO.self) { response in
                if let statusCode = response.response?.statusCode {
                    if statusCode == 401 {
                        // 토큰 재요청 함수 호출
                        LoginAPI.shared.refreshAccessToken { result in
                            switch result {
                            case .success(let loginDTO):
                                print("토큰 재발급 성공: \(loginDTO)")
                            case .failure(let error):
                                print("토큰 재발급 실패: \(error)")
                            }
                        }
                    }
                }
                print("알림 목록 불러오기 성공\(response.response?.statusCode)")
                completion(response.result)
            }
    }
}
