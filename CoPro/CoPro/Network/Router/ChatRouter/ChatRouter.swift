//
//  ChatRouter.swift
//  CoPro
//
//  Created by 박신영 on 2/26/24.
//

import Foundation
import Alamofire

enum ChatRouter {
    case getOppositeInfo(token: String, email: String)
}

extension ChatRouter: BaseTargetType {

    var baseURL: String { return Config.baseURL }

    var method: HTTPMethod {
        switch self {
        case .getOppositeInfo:
            return .get
        }
    }

    var path: String {
        switch self {
        case .getOppositeInfo(_, let email):
            return "/api/chatting/profile/\(email)"
        }
    }

    var parameters: RequestParams {
        switch self {
        case .getOppositeInfo:
            return .none
        }
    }

    var headers : HTTPHeaders?{
        switch self{
        case .getOppositeInfo(let token, _):
            return ["Authorization": "Bearer \(token)"]
        }
    }
}
