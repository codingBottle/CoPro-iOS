//
//  MyProfileRouter.swift
//  CoPro
//
//  Created by 박신영 on 1/21/24.
//

import Foundation
import Alamofire

enum MyProfileRouter {
    case getMyPfoile(token: String)
}

extension MyProfileRouter: BaseTargetType {

    var baseURL: String { return Config.baseURL }

    var method: HTTPMethod {
        switch self {
        case .getMyPfoile:
            return .get
        }
        
    }

    var path: String {
        switch self {
        case .getMyPfoile:
            return "/api/profile"
        }
    }

    var parameters: RequestParams {
        switch self {
        case .getMyPfoile:
            return .none
        }
    }

    var headers : HTTPHeaders?{
        switch self{
        case .getMyPfoile(let token):
            return ["Authorization": "Bearer \(token)"]
            
        }
    }
}
