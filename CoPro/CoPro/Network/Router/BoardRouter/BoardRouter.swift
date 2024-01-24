//
//  BoardRouter.swift
//  CoPro
//
//  Created by 문인호 on 1/16/24.
//

import Foundation

import Alamofire

enum BoardRouter {
    case reportBoard(token: String, requestBody: ReportBoardRequestBody)
    case getAllBoard(token: String, category: String, page: Int, standard: String)
    case getDetailBoard(token: String, boardId: Int)
    case editBoard(token: String, boardId: Int, requestBody: CreateBoardRequestBody)
    case addBoard(token: String, requestBody: CreateBoardRequestBody)
    case deleteBoard(token: String, boardId: Int)
    case requestWritePage(token: String, category: String)
    case saveHeart(token: String, requestBody: heartRequestBody)
    case deleteHeart(token: String, requestBody: heartRequestBody)
    case mostPopularBoard(token: String)
    case deleteScrap(token: String, requestBody: heartRequestBody)
    case saveScrap(token: String, requestBody: heartRequestBody)
    case searchBoard(token: String, query: String, page: Int, standard: String)
//    case sortLikes(token: String)
}

extension BoardRouter: BaseTargetType {
    
    var baseURL: String { return Config.baseURL }
    
    var method: HTTPMethod {
        switch self {
        case .getAllBoard:
            return .get
        case .getDetailBoard:
            return .get
        case .editBoard:
            return .put
        case .addBoard:
            return .post
        case .deleteBoard:
            return .delete
        case .requestWritePage:
            return .get
        case .saveHeart:
            return .post
        case .deleteHeart:
            return .delete
        case .mostPopularBoard:
            return .get
        case .deleteScrap:
            return .delete
        case .saveScrap:
            return .post
        case .searchBoard:
            return .get
            //        case .sortLikes:
            //            return .put
        case .reportBoard:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getAllBoard(_,let category,_,_):
            return "/api/board/list/\(category)"
        case  .getDetailBoard:
            return "/api/board"
        case .editBoard:
            return "/api/board"
        case .addBoard:
            return "/api/board"
        case .deleteBoard:
            return "/api/board"
        case .requestWritePage(_, let category):
            return "/api/board/\(category)"
        case .saveHeart:
            return "/api/board/heart/save"
        case .deleteHeart:
            return "/api/board/heart"
        case .mostPopularBoard:
            return "/api/board/most-increased-hearts"
        case .deleteScrap:
            return "/api/board/scrap"
        case .saveScrap:
            return "/api/board/scrap/save"
        case .searchBoard:
            return "/api/board/search"
        case .reportBoard(token: let token, requestBody: let requestBody):
            return "/api/report"
        }
    }
    var parameters: RequestParams {
        switch self {
        case .getAllBoard(_, _, let page, let standard):
            let requestModel = allBoardRequestBody(page: page, standard: standard)
            return .query(requestModel)
        case .getDetailBoard(_, let boardId):
            let requestModel = DetailBoardRequestBody(boardID: boardId)
            return .query(requestModel)
        case .editBoard(_, let boardId, let requestBody):
            return .both(boardId, _parameter: requestBody)
        case .addBoard(_, let requestBody):
            return .body(requestBody)
        case .deleteBoard(_, let boardId):
            return .query(boardId)
        case .requestWritePage:
            return .none
        case .saveHeart(_, let body):
            return .body(body)
        case .deleteHeart(_, let body):
            return .body(body)
        case .mostPopularBoard:
            return .none
        case .deleteScrap(_, let body):
            return .body(body)
        case .saveScrap(_, let body):
            return .body(body)
        case .searchBoard(_, let query, let page, let standard):
            let requestModel = SearchBoardRequestBody(q: query, page: page, standard: standard)
            return .query(requestModel)
        case .reportBoard(_, let requestBody):
            return .body(requestBody)
        }
    }
    
    var headers : HTTPHeaders?{
        switch self{
        case .getAllBoard(let token, _, _, _):
            return ["Authorization": "Bearer \(token)"]
        case .getDetailBoard(let token, _):
            return ["Authorization": "Bearer \(token)"]
        case .editBoard(let token, _, _):
            return ["Authorization": "Bearer \(token)"]
        case .addBoard(let token, _):
            return ["Authorization": "Bearer \(token)"]
        case .deleteBoard(let token, _):
            return ["Authorization": "Bearer \(token)"]
        case .requestWritePage(let token, _):
            return ["Authorization": "Bearer \(token)"]
        case .saveHeart(let token, _):
            return ["Authorization": "Bearer \(token)"]
        case .deleteHeart(let token, _):
            return ["Authorization": "Bearer \(token)"]
        case .mostPopularBoard(let token):
            return ["Authorization": "Bearer \(token)"]
        case .deleteScrap(let token, _):
            return ["Authorization": "Bearer \(token)"]
        case .saveScrap(let token, _):
            return ["Authorization": "Bearer \(token)"]
        case .searchBoard(let token, _, _, _):
            return ["Authorization": "Bearer \(token)"]
        case .reportBoard(let token, _):
            return ["Authorization": "Bearer \(token)"]
        }
    }
}
