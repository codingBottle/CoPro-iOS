//
//  CardAPI.swift
//  CoPro
//
//  Created by 박현렬 on 1/9/24.
//

import Foundation
import KeychainSwift
import Alamofire

final class CardAPI : BaseAPI {
    static let shared = CardAPI()
    
    private override init() {}
}
extension CardAPI {
    // CardViewController User API 데이터를 불러오는 메서드
    func getUserData(part: String, lang: String, old: Int, page: Int,completion: @escaping (Result<CardDTO, AFError>) -> Void){
        //keychain 토큰가저오기
        let keychain = KeychainSwift()
        guard let token = keychain.get("idToken") else {
            print("No token found in keychain.")
            return
        }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        // Body 설정
        let parameters: Parameters = [
            "memberId" : 17,
            "occupation": part == "직군" ? " " : part,
            "language": lang == "언어" ? " " :lang,
            "career": old,
            "page":page,
            "size":10
            
        ]
        AF.request("BASE_API/api/infos", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .responseDecodable(of: CardDTO.self) { response in
                completion(response.result)
            }
        
        
    }
    func addLike(MemberId : Int, completion: @escaping (Bool) -> Void){
        let keychain = KeychainSwift()
        guard let token = keychain.get("idToken") else {
            print("No token found in keychain.")
            return
        }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        
        // 전송할 Request Body 설정
        let parameters: [String: Any] = ["likeMemberId": MemberId]
        
        // Alamofire를 사용하여 POST 요청
        AF.request("BASE_API/api/add-like", method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers)
            .validate() // 서버 응답이 성공적인지 확인
            .responseJSON { response in
                switch response.result {
                case .success:
                    // 성공적으로 응답을 받았을 때
                    completion(true)
                case .failure(let error):
                    // API 요청이 실패했을 때
                    print("Error: \(error)")
                    completion(false)
                }
            }
    }
    func cancelLike(MemberId : Int, completion: @escaping (Bool) -> Void){
        let keychain = KeychainSwift()
        guard let token = keychain.get("idToken") else {
            print("No token found in keychain.")
            return
        }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        
        // 전송할 Request Body 설정
        let parameters: [String: Any] = ["likeMemberId": MemberId]
        
        // Alamofire를 사용하여 POST 요청
        AF.request("BASE_API/api/cancel-like", method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers)
            .validate() // 서버 응답이 성공적인지 확인
            .responseJSON { response in
                switch response.result {
                case .success:
                    // 성공적으로 응답을 받았을 때
                    completion(true)
                case .failure(let error):
                    // API 요청이 실패했을 때
                    print("Error: \(error)")
                    completion(false)
                }
            }
    }
}
