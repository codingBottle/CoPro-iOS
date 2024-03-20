//
//  MyProfileAPI.swift
//  CoPro
//
//  Created by 박신영 on 1/21/24.
//

import Foundation
import Alamofire
import UIKit
import KeychainSwift

final class MyProfileAPI: BaseAPI {
    static let shared = MyProfileAPI()
   let keychain = KeychainSwift()

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
   
   /// MARK: - ProfileImage 수정
  public func addProfileImage(token: String,
                                       requestBody: AddProfilePhotoRequestBody,
                                completion: @escaping(NetworkResult<Any>) -> Void) {
     
     AFManager.request(MyProfileRouter.addProfiePhoto(token: token, requestBody: requestBody)).responseData { response in
        if let statusCode = response.response?.statusCode {
           if statusCode == 401 {
              // 토큰 재요청 함수 호출
              LoginAPI.shared.refreshAccessToken { result in
                 switch result {
                 case .success(let loginDTO):
                    print("토큰 재발급 성공: \(loginDTO)")
                    DispatchQueue.main.async {
                       self.addProfileImage(token: loginDTO.data.accessToken, requestBody: requestBody, completion: completion)
                    }
                 case .failure(let error):
                    print("토큰 재발급 실패: \(error)")
                 }
              }
           } else {
              print("프로필 이미지 등록 성공")
              self.disposeNetwork(response, dataModel: AddProfilePhotoDTO.self, completion: completion)
           }
        } else {
           // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
           self.disposeNetwork(response, dataModel: AddProfilePhotoDTO.self, completion: completion)
        }
     }
  }
   
   
   /// MARK: - MyProfile 수정
  public func deleteProfileImage(token: String,
                                       requestBody: DeleteProfilePhotoRequestBody,
                                completion: @escaping(NetworkResult<Any>) -> Void) {
     
     AFManager.request(MyProfileRouter.deleteProfiePhoto(token: token, requestBody: requestBody)).responseData { response in
        if let statusCode = response.response?.statusCode {
           if statusCode == 401 {
              // 토큰 재요청 함수 호출
              LoginAPI.shared.refreshAccessToken { result in
                 switch result {
                 case .success(let loginDTO):
                    print("토큰 재발급 성공: \(loginDTO)")
                    DispatchQueue.main.async {
                       self.deleteProfileImage(token: loginDTO.data.accessToken, requestBody: requestBody, completion: completion)
                    }
                 case .failure(let error):
                    print("토큰 재발급 실패: \(error)")
                 }
              }
           } else {
              print("프로필 이미지 삭제 성공")
              self.disposeNetwork(response, dataModel: DeleteProfilePhotoDTO.self, completion: completion)
           }
        } else {
           // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
           self.disposeNetwork(response, dataModel: DeleteProfilePhotoDTO.self, completion: completion)
        }
     }
  }
    
   
    /// MARK: - MyProfile 수정
   public func postEditMyProfile(token: String,
                                        requestBody: EditMyProfileRequestBody,
                                 checkFirstlogin: Bool,
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
                        self.postEditMyProfile(token: loginDTO.data.accessToken, requestBody: requestBody, checkFirstlogin: checkFirstlogin, completion: completion)
                     }
                  case .failure(let error):
                     print("토큰 재발급 실패: \(error)")
                  }
               }
            } else {
               print("프로필 수정 성공")
               self.disposeNetwork(response, dataModel: EditMyProfileDTO.self, completion: completion)
//               let editMyProfileVC = EditMyProfileViewController()
//               if checkFirstlogin {
//                  // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
//                  self.postFcmToken()
//                  print("🍎🍎🍎🍎🍎🍎🍎checkFirstlogin true / postFcmToken 성공🍎🍎🍎🍎🍎🍎🍎🍎🍎")
//                  self.disposeNetwork(response, dataModel: EditMyProfileDTO.self, completion: completion)
//               } else {
//
//                  
//                  if statusCode == 200 {
//                     self.disposeNetwork(response, dataModel: EditMyProfileDTO.self, completion: completion)
//                     print("🅾️현재 MyProfileRouter.postEditMyProfile StatusCode 200 🅾️")
//                  } else {
//                     print("❌현재 MyProfileRouter.postEditMyProfile StatusCode 200 아님❌")
//                  }
//                  
//               }
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
                                  checkFirstlogin: Bool,
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
                              self.postEditGitHubURL(token: loginDTO.data.accessToken, requestBody: requestBody, checkFirstlogin: checkFirstlogin, completion: completion)
                           }
                       case .failure(let error):
                           print("토큰 재발급 실패: \(error)")
                       }
                   }
               } else {
                  
                  // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                  
                  print("🔥\(response)")
                  if checkFirstlogin {
                     print("현재 깃헙모달에서 checkfirstlogin true")
                     self.disposeNetwork(response, dataModel: EditGitHubURLDTO.self, completion: completion)
                  }
                  else {
                     print("현재 깃헙모달에서 checkfirstlogin false")
                     self.disposeNetwork(response, dataModel: EditGitHubURLDTO.self, completion: completion)
                  }
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
   
   
   func postFcmToken() {
      print("🔥")
      
       guard let token = self.keychain.get("accessToken") else {
           print("No accessToken found in keychain.")
           return
       }
      guard let fcmToken = keychain.get("FcmToken") else {return print("postFcmToken 안에 FcmToken 설정 에러")}
      
      NotificationAPI.shared.postFcmToken(token: token, requestBody: FcmTokenRequestBody(fcmToken: fcmToken)) { result in
           switch result {
           case .success(_):
              print("FcmToken 보내기 성공")
               
           case .requestErr(let message):
               // 요청 에러인 경우
               print("Error : \(message)")
              if (message as AnyObject).contains("401") {
                   // 만료된 토큰으로 인해 요청 에러가 발생한 경우
               }
               
           case .pathErr, .serverErr, .networkFail:
               // 다른 종류의 에러인 경우
               print("another Error")
           default:
               break
           }
       }
   }
}
