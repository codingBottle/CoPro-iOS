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
    case getWritebyMe(token: String)
    case getMyWrittenComment(token: String)
    case getScrapPost(token: String)
    case getNickNameDuplication(token: String, nickname: String)
    case postEditGitHubURL(token: String, requestBody: EditGitHubURLRequestBody)
    case postEditCardType(token: String, requestBody: EditCardTypeRequestBody)
    case postEditMyProfile(token: String, requestBody: EditMyProfileRequestBody)
}

extension MyProfileRouter: BaseTargetType {

    var baseURL: String { return Config.baseURL }

    var method: HTTPMethod {
        switch self {
        case .getMyPfoile:
            return .get
            
        case .getWritebyMe:
            return .get
            
        case .getMyWrittenComment:
            return .get
            
        case .getScrapPost:
            return .get
            
        case .getNickNameDuplication:
            return .get
            
        case .postEditGitHubURL:
            return .post
            
        case .postEditCardType:
            return .post
            
        case .postEditMyProfile:
            return .post
        }
    }

    var path: String {
        switch self {
        case .getMyPfoile:
            return "/api/profile"
            
        case .getWritebyMe:
            return "/api/board/write"
        
        case .getMyWrittenComment:
            return "/api/comment/write"
            
        case .getScrapPost:
            return "/api/scrap"
            
        case .getNickNameDuplication(_, _):
            return "/api/nickname"
//        case .getNickNameDuplication(_, let nickname):
//            return "/api/nickname/\(nickname)"
            
        case .postEditGitHubURL:
            return "/api/github-url"
            
        case .postEditCardType:
            return "/api/view-type"
            
        case .postEditMyProfile:
            return "/api/profile"
        }
    }

    var parameters: RequestParams {
        switch self {
        case .getMyPfoile:
            return .none
            
        case .getWritebyMe:
            return .none
            
        case .getMyWrittenComment:
            return .none
        
        case .getScrapPost:
            return .none
          
        case .getNickNameDuplication(_, let nickname):
            return .query(["nickname": nickname])

//        case .getNickNameDuplication:
//            return .none
            
//        case .getNickNameDuplication(_, let nickname):
//            return .query(nickname)
            
        case .postEditGitHubURL(_, let requestBody):
            return .body(requestBody)
            
        case .postEditCardType(_, let requestBody):
            return .body(requestBody)
            
        case .postEditMyProfile(_, let requestBody):
            return .body(requestBody)
        }
    }

    var headers : HTTPHeaders?{
        switch self{
        case .getMyPfoile(let token):
            return ["Authorization": "Bearer \(token)"]
        
        case .getWritebyMe(let token):
            return ["Authorization": "Bearer \(token)"]
            
        case .getMyWrittenComment(let token):
            return ["Authorization": "Bearer \(token)"]
            
        case .getScrapPost(let token):
            return ["Authorization": "Bearer \(token)"]
        
            
//        case .getNickNameDuplication(let token):
//            return ["Authorization": "Bearer \(token)"]
        case .getNickNameDuplication(let token, _):
            return ["Authorization": "Bearer \(token)"]
            
        case .postEditGitHubURL(let token, _):
            return ["Authorization": "Bearer \(token)"]
            
        case .postEditCardType(let token, _):
            return ["Authorization": "Bearer \(token)"]
            
        case .postEditMyProfile(let token, _):
            return ["Authorization": "Bearer \(token)"]
        }
    }
}
