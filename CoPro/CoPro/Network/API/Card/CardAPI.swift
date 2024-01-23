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
    func getUserData(part: String, lang: String, old: String, page: Int,completion: @escaping (Result<CardDTO, AFError>) -> Void){
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
            "career": old == "경력" ? " " : old,
            "page":page,
            "size":10
            
        ]
        AF.request("API_URL", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
                    .responseDecodable(of: CardDTO.self) { response in
                        completion(response.result)
                    }
        
        
    }
}
