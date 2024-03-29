//
//  OppositeInfoAPI.swift
//  CoPro
//
//  Created by 박신영 on 2/26/24.
//

import Foundation
import Alamofire

final class OppositeInfoAPI: BaseAPI {
    static let shared = OppositeInfoAPI()

    private override init() {}
}

extension OppositeInfoAPI {
   
   // MARK: - Post FcmToken
   
   public func getOppositeInfo(token: String, email: String, completion: @escaping(NetworkResult<Any>) -> Void) {
       AFManager.request(ChatRouter.getOppositeInfo(token: token, email: email)).responseData { response in
          
          if let statusCode = response.response?.statusCode {
              if statusCode == 401 {
                  // 토큰 재요청 함수 호출
                  LoginAPI.shared.refreshAccessToken { result in
                      switch result {
                      case .success(let loginDTO):
                          print("토큰 재발급 성공: \(loginDTO)")
                          DispatchQueue.main.async {
                             self.getOppositeInfo(token: loginDTO.data.accessToken, email: email, completion: completion)
                          }
                      case .failure(let error):
                          print("토큰 재발급 실패: \(error)")
                      }
                  }
              } else {
                  // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                  self.disposeNetwork(response, dataModel: OppositeInfoDTO.self, completion: completion)
              }
          } else {
              // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
              self.disposeNetwork(response, dataModel: OppositeInfoDTO.self, completion: completion)
          }

       }
   }
}

