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
            self.disposeNetwork(response,
                                dataModel: MyProfileDTO.self,
                                completion: completion)
        }
    }
    
    // MARK: - MyProfile 수정
    
    public func postEditMyProfile(token: String,
                                  requestBody: EditMyProfileRequestBody,
                                  completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(MyProfileRouter.postEditMyProfile(token: token, requestBody: requestBody)).responseData { response in
            self.disposeNetwork(response,
                                dataModel: EditMyProfileDTO.self,
                                completion: completion)
        }
    }
    
    // MARK: - Github URL 수정
    
    public func postEditGitHubURL(token: String,
                                  requestBody: EditGitHubURLRequestBody,
                                  completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(MyProfileRouter.postEditGitHubURL(token: token, requestBody: requestBody)).responseData { response in
            self.disposeNetwork(response,
                                dataModel: EditMyProfileDTO.self,
                                completion: completion)
        }
    }
    
    // MARK: - 카드뷰 타입 수정
    
    public func postEditCardType(token: String,
                                 requestBody: EditCardTypeRequestBody,
                                 completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(MyProfileRouter.postEditCardType(token: token, requestBody: requestBody)).responseData { response in
           self.disposeNetwork(response,
                               dataModel: EditCardTypeDTO.self,
                               completion: completion)
       }
   }
    
    // MARK: - 내가 작성한 게시물 조회
    
    public func getWritebyMe(token: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(MyProfileRouter.getWritebyMe(token: token)).responseData { response in
            self.disposeNetwork(response,
                                dataModel: WritebyMeDTO.self,
                                completion: completion)
        }
    }
    
    // MARK: - 내가 작성한 댓글 조회
    
    public func getMyWrittenComment(token: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(MyProfileRouter.getMyWrittenComment(token: token)).responseData { response in
            self.disposeNetwork(response,
                                dataModel: MyWrittenCommentDTO.self,
                                completion: completion)
        }
    }
    
    // MARK: - 스크랩 게시글 조회
    
    public func getScrapPost(token: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(MyProfileRouter.getScrapPost(token: token)).responseData { response in
            self.disposeNetwork(response,
                                dataModel: ScrapPostDTO.self,
                                completion: completion)
        }
    }
    
    // MARK: - 닉네임 중복확인
    
    public func getNickNameDuplication(token: String, nickname: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(MyProfileRouter.getNickNameDuplication(token: token, nickname: nickname)).responseData { response in
            self.disposeNetwork(response,
                                dataModel: getNickNameDuplicationDTO.self,
                                completion: completion)
        }
    }
}
