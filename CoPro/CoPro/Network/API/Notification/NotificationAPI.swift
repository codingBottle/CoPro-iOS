//
//  NotificationAPI.swift
//  CoPro
//
//  Created by 박신영 on 2/19/24.
//

import Foundation
import Alamofire

final class NotificationAPI: BaseAPI {
    static let shared = NotificationAPI()

    private override init() {}
}

extension NotificationAPI {
   
   // MARK: - Post FcmToken
   
   public func postFcmToken(token: String,
                            requestBody: FcmTokenRequestBody,
                            completion: @escaping(NetworkResult<Any>) -> Void) {
      AFManager.request(NotificationRouter.postFcmToken(token: token, requestBody: requestBody)).responseData { response in
         self.disposeNetwork(response,
                             dataModel: FcmTokenDTO.self,
                             completion: completion)
      }
   }
   
}
