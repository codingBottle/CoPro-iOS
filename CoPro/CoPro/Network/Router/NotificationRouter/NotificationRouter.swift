//
//  NotificationRouter.swift
//  CoPro
//
//  Created by 박신영 on 2/19/24.
//

import Foundation
import Alamofire

enum NotificationRouter {
   case postFcmToken(token: String, requestBody: FcmTokenRequestBody)
}

extension NotificationRouter: BaseTargetType {

    var baseURL: String { return Config.baseURL }

    var method: HTTPMethod {
        switch self {
        case .postFcmToken:
            return .post
        }
    }

    var path: String {
        switch self {
        case .postFcmToken:
            return "/api/fcm-token"
        }
    }

    var parameters: RequestParams {
        switch self {
        case .postFcmToken(_, let requestBody):
            return .body(requestBody)
        }
    }

    var headers : HTTPHeaders?{
        switch self{
        case .postFcmToken(let token, _):
            return ["Authorization": "Bearer \(token)"]
        }
    }
}
