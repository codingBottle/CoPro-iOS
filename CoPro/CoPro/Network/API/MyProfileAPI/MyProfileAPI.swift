//
//  MyProfileAPI.swift
//  CoPro
//
//  Created by 박신영 on 1/21/24.
//

import Foundation
import Alamofire

final class MyProfileAPI: BaseAPI {
    static let shared = MyProfileAPI()

    private override init() {}
}

extension MyProfileAPI {
    
    // MARK: - 전체 루트추천 조회
    
    public func getMyProfile(token: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(MyProfileRouter.getMyPfoile(token: token)).responseData { response in
           
           if let statusCode = response.response?.statusCode {
               if statusCode == 401 {
                   // 토큰 재요청 함수 호출
                   LoginAPI.shared.refreshAccessToken { result in
                       switch result {
                       case .success(let loginDTO):
                           print("토큰 재발급 성공: \(loginDTO)")
                           DispatchQueue.main.async {
                               self.getMyProfile(token: loginDTO.data.accessToken, completion: completion)
                           }
                       case .failure(let error):
                           print("토큰 재발급 실패: \(error)")
                       }
                   }
               } else {
                   // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                   self.disposeNetwork(response, dataModel: MyProfileDTO.self, completion: completion)
               }
           } else {
               // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
               self.disposeNetwork(response, dataModel: MyProfileDTO.self, completion: completion)
           }

        }
    }
    
   
    /// MARK: - MyProfile 수정
   public func postEditMyProfile(token: String,
                                        requestBody: EditMyProfileRequestBody,
                                        completion: @escaping(NetworkResult<Any>) -> Void) {
          AFManager.request(MyProfileRouter.postEditMyProfile(token: token, requestBody: requestBody)).responseData { response in
              if let statusCode = response.response?.statusCode {
                  if statusCode == 401 {
                      // 토큰 재요청 함수 호출
                      LoginAPI.shared.refreshAccessToken { result in
                          switch result {
                          case .success(let loginDTO):
                              print("토큰 재발급 성공: \(loginDTO)")
                              DispatchQueue.main.async {
                                  self.postEditMyProfile(token: loginDTO.data.accessToken, requestBody: requestBody, completion: completion)
                              }
                          case .failure(let error):
                              print("토큰 재발급 실패: \(error)")
                          }
                      }
                  } else {
                      // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                      self.disposeNetwork(response, dataModel: EditMyProfileDTO.self, completion: completion)
                  }
              } else {
                  // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
                  self.disposeNetwork(response, dataModel: EditMyProfileDTO.self, completion: completion)
              }
          }
      }
    
   
    /// MARK: - Github URL 수정
    public func postEditGitHubURL(token: String,
                                  requestBody: EditGitHubURLRequestBody,
                                  completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(MyProfileRouter.postEditGitHubURL(token: token, requestBody: requestBody)).responseData { response in
           if let statusCode = response.response?.statusCode {
               if statusCode == 401 {
                   // 토큰 재요청 함수 호출
                   LoginAPI.shared.refreshAccessToken { result in
                       switch result {
                       case .success(let loginDTO):
                           print("토큰 재발급 성공: \(loginDTO)")
                           DispatchQueue.main.async {
                              self.postEditGitHubURL(token: loginDTO.data.accessToken, requestBody: requestBody, completion: completion)
                           }
                       case .failure(let error):
                           print("토큰 재발급 실패: \(error)")
                       }
                   }
               } else {
                   // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                   self.disposeNetwork(response, dataModel: EditGitHubURLDTO.self, completion: completion)
               }
           } else {
               // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
               self.disposeNetwork(response, dataModel: EditGitHubURLDTO.self, completion: completion)
           }
        }
    }
    
   
    /// MARK: - 카드뷰 타입 수정
    public func postEditCardType(token: String,
                                 requestBody: EditCardTypeRequestBody,
                                 completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(MyProfileRouter.postEditCardType(token: token, requestBody: requestBody)).responseData { response in
           
           if let statusCode = response.response?.statusCode {
               if statusCode == 401 {
                   // 토큰 재요청 함수 호출
                   LoginAPI.shared.refreshAccessToken { result in
                       switch result {
                       case .success(let loginDTO):
                           print("토큰 재발급 성공: \(loginDTO)")
                           DispatchQueue.main.async {
                               self.postEditCardType(token: loginDTO.data.accessToken, requestBody: requestBody, completion: completion)
                           }
                       case .failure(let error):
                           print("토큰 재발급 실패: \(error)")
                       }
                   }
               } else {
                   // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                   self.disposeNetwork(response, dataModel: EditCardTypeDTO.self, completion: completion)
               }
           } else {
               // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
               self.disposeNetwork(response, dataModel: EditCardTypeDTO.self, completion: completion)
           }
           
       }
   }
    
   
    /// MARK: - 내가 작성한 게시물 조회
    public func getWritebyMe(token: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(MyProfileRouter.getWritebyMe(token: token)).responseData { response in
           if let statusCode = response.response?.statusCode {
               if statusCode == 401 {
                   // 토큰 재요청 함수 호출
                   LoginAPI.shared.refreshAccessToken { result in
                       switch result {
                       case .success(let loginDTO):
                           print("토큰 재발급 성공: \(loginDTO)")
                           DispatchQueue.main.async {
                               self.getWritebyMe(token: loginDTO.data.accessToken, completion: completion)
                           }
                       case .failure(let error):
                           print("토큰 재발급 실패: \(error)")
                       }
                   }
               } else {
                   // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                   self.disposeNetwork(response, dataModel: WritebyMeDTO.self, completion: completion)
               }
           } else {
               // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
               self.disposeNetwork(response, dataModel: WritebyMeDTO.self, completion: completion)
           }
        }
    }
    
   
    /// MARK: - 내가 작성한 댓글 조회
    public func getMyWrittenComment(token: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(MyProfileRouter.getMyWrittenComment(token: token)).responseData { response in
           if let statusCode = response.response?.statusCode {
               if statusCode == 401 {
                   // 토큰 재요청 함수 호출
                   LoginAPI.shared.refreshAccessToken { result in
                       switch result {
                       case .success(let loginDTO):
                           print("토큰 재발급 성공: \(loginDTO)")
                           DispatchQueue.main.async {
                               self.getMyWrittenComment(token: loginDTO.data.accessToken, completion: completion)
                           }
                       case .failure(let error):
                           print("토큰 재발급 실패: \(error)")
                       }
                   }
               } else {
                   // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                   self.disposeNetwork(response, dataModel: MyWrittenCommentDTO.self, completion: completion)
               }
           } else {
               // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
               self.disposeNetwork(response, dataModel: MyWrittenCommentDTO.self, completion: completion)
           }
        }
    }
    
   
    /// MARK: - 스크랩 게시글 조회
    public func getScrapPost(token: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(MyProfileRouter.getScrapPost(token: token)).responseData { response in
           if let statusCode = response.response?.statusCode {
               if statusCode == 401 {
                   // 토큰 재요청 함수 호출
                   LoginAPI.shared.refreshAccessToken { result in
                       switch result {
                       case .success(let loginDTO):
                           print("토큰 재발급 성공: \(loginDTO)")
                           DispatchQueue.main.async {
                               self.getScrapPost(token: loginDTO.data.accessToken, completion: completion)
                           }
                       case .failure(let error):
                           print("토큰 재발급 실패: \(error)")
                       }
                   }
               } else {
                   // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                   self.disposeNetwork(response, dataModel: ScrapPostDTO.self, completion: completion)
               }
           } else {
               // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
               self.disposeNetwork(response, dataModel: ScrapPostDTO.self, completion: completion)
           }

        }
    }
    
   
    /// MARK: - 닉네임 중복확인
    public func getNickNameDuplication(token: String, nickname: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(MyProfileRouter.getNickNameDuplication(token: token, nickname: nickname)).responseData { response in
           if let statusCode = response.response?.statusCode {
               if statusCode == 401 {
                   // 토큰 재요청 함수 호출
                   LoginAPI.shared.refreshAccessToken { result in
                       switch result {
                       case .success(let loginDTO):
                           print("토큰 재발급 성공: \(loginDTO)")
                           DispatchQueue.main.async {
                               self.getNickNameDuplication(token: loginDTO.data.accessToken, nickname: nickname, completion: completion)
                           }
                       case .failure(let error):
                           print("토큰 재발급 실패: \(error)")
                       }
                   }
               } else {
                   // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                   self.disposeNetwork(response, dataModel: getNickNameDuplicationDTO.self, completion: completion)
               }
           } else {
               // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
               self.disposeNetwork(response, dataModel: getNickNameDuplicationDTO.self, completion: completion)
           }
        }
    }
}
