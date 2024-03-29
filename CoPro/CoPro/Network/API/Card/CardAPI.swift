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
    var baseURL: String { return Config.baseURL }
    // CardViewController User API 데이터를 불러오는 메서드
    func getUserData(part: String, lang: String, old: Int, page: Int,completion: @escaping (Result<CardDTO, AFError>) -> Void){
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
        var rePart = " "
        var reLang = " "
        if part == "직무" || part == "전체"{
            rePart = " "
        }else{
            rePart = part
        }
        if lang == "언어" || lang == "전체"{
            reLang = " "
        }else{
            reLang = lang
        }
        // Body 설정
        let parameters: Parameters = [
            "occupation": rePart,
            "language": reLang,
            "career": old,
            "page":page,
            "size":10
            
        ]
        AF.request("\(baseURL)/api/infos", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .responseDecodable(of: CardDTO.self) { response in
                if let statusCode = response.response?.statusCode {
                    if statusCode == 401 {
                        // 토큰 재요청 함수 호출
                        LoginAPI.shared.refreshAccessToken { result in
                            switch result {
                            case .success(let loginDTO):
                                print("토큰 재발급 성공: \(loginDTO)")
                                
                                DispatchQueue.main.async {
                                    // 토큰 재발급이 성공한 후 reloadData() 호출
                                    CardViewController().reloadData()
                                }
                            case .failure(let error):
                                print("토큰 재발급 실패: \(error)")
                            }
                        }
                    } else {
                        print("\(rePart)//\(reLang)//\(old)//\(page)")
                        // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                        completion(response.result)
                    }
                }
            }
    }
    // MARK: - 프로필 관심프로필
    func getLikeUser(page: Int,completion: @escaping (Result<LikeProfileDTO, AFError>) -> Void){
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
        
        // Body 설정
        let parameters: Parameters = [
            "page":page,
            "size":10
            
        ]
        AF.request("\(baseURL)/api/likes", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .responseDecodable(of: LikeProfileDTO.self) { response in
                if let statusCode = response.response?.statusCode {
                    if statusCode == 401 {
                        // 토큰 재요청 함수 호출
                        LoginAPI.shared.refreshAccessToken { result in
                            switch result {
                            case .success(let loginDTO):
                                print("토큰 재발급 성공: \(loginDTO)")
                                
                                DispatchQueue.main.async {
                                    // 토큰 재발급이 성공한 후 reloadData() 호출
                                    CardViewController().reloadData()
                                }
                            case .failure(let error):
                                print("토큰 재발급 실패: \(error)")
                            }
                        }
                    } else {
                        // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                        completion(response.result)
                    }
                }
            }
        
        
    }
    
    func addLike(MemberId : Int, completion: @escaping (Bool) -> Void){
        let keychain = KeychainSwift()
        guard let token = keychain.get("accessToken") else {
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
        AF.request("\(baseURL)/api/add-like", method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers)
            .validate() // 서버 응답이 성공적인지 확인
            .responseJSON {response in
                if let statusCode = response.response?.statusCode {
                    if statusCode == 401 {
                        // 토큰 재요청 함수 호출
                        LoginAPI.shared.refreshAccessToken { result in
                            switch result {
                            case .success(let loginDTO):
                                print("토큰 재발급 성공: \(loginDTO)")
                                
                                DispatchQueue.main.async {
                                    // 토큰 재발급이 성공한 후 reloadData() 호출
                                    CardViewController().reloadData()
                                }
                            case .failure(let error):
                                print("토큰 재발급 실패: \(error)")
                            }
                        }
                    } else {
                        // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                        completion(true)
                    }
                }
            }
        
    }
    func cancelLike(MemberId : Int, completion: @escaping (Bool) -> Void){
        let keychain = KeychainSwift()
        guard let token = keychain.get("accessToken") else {
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
        AF.request("\(baseURL)/api/cancel-like", method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers)
            .validate() // 서버 응답이 성공적인지 확인
            .responseJSON { response in
                if let statusCode = response.response?.statusCode {
                    if statusCode == 401 {
                        // 토큰 재요청 함수 호출
                        LoginAPI.shared.refreshAccessToken { result in
                            switch result {
                            case .success(let loginDTO):
                                print("토큰 재발급 성공: \(loginDTO)")
                                
                                DispatchQueue.main.async {
                                    // 토큰 재발급이 성공한 후 reloadData() 호출
                                    CardViewController().reloadData()
                                }
                            case .failure(let error):
                                print("토큰 재발급 실패: \(error)")
                            }
                        }
                    } else {
                        // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                        completion(true)
                    }
                }
            }
    }
}

