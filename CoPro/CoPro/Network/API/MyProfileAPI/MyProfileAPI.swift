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
}
