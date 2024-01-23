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
//    // Alamofire을 사용한 API 요청
//    AF.request("http://43.202.172.4:8091/api/infos", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
//        .responseDecodable(of: CardDTO.self) { response in
//            switch response.result {
//            case .success(let cardDTO):
//                print("Api Response Success \(response)")
//                self.contents.append(contentsOf: cardDTO.data.memberResDto.content)
//                self.last = cardDTO.data.memberResDto.last
//                self.myViewType = cardDTO.data.myViewType
//                print("myViewType : \(cardDTO.data.myViewType)")
//                DispatchQueue.main.async {
//                    //ViewType에 따른 스크롤 방향 결정
//                    let scrollDirection: UICollectionView.ScrollDirection = (self.myViewType == 0) ? .horizontal : .vertical
//
//                    if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//                        layout.scrollDirection = scrollDirection
//                        self.collectionView.isPagingEnabled = (scrollDirection == .horizontal)
//                    }
//                    self.collectionView.reloadData()
//                    
//                }
//            case .failure(let error):
//                print("Api Response Error: \(error)")
//            }
//        }
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
        AF.request("http://43.202.172.4:8091/api/infos", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
                    .responseDecodable(of: CardDTO.self) { response in
                        completion(response.result)
                    }
        
        
    }
}
