//
//  BoardRouter.swift
//  CoPro
//
//  Created by 문인호 on 1/16/24.
//

import Foundation

import Alamofire
import UIKit

enum BoardRouter {
    case reportBoard(token: String, boardId: Int, contents: String)
    case getAllBoard(token: String, category: String, page: Int, standard: String)
    case getDetailBoard(token: String, boardId: Int)
    case editBoard(token: String, boardId: Int, requestBody: CreatePostRequestBody)
    case addPhoto(token: String, images: [UIImage])
    case addPost(token: String, title: String, category: String, contents: String, imageid: [String])
    case deleteBoard(token: String, boardId: Int)
    case requestWritePage(token: String, category: String)
    case saveHeart(token: String, boardId: Int)
    case deleteHeart(token: String, boardId: Int)
    case mostPopularBoard(token: String)
    case deleteScrap(token: String, boardId: Int)
    case saveScrap(token: String, boardId: Int)
    case searchBoard(token: String, query: String, page: Int, standard: String)
//    case sortLikes(token: String)
    case getAllComment(token: String, boardId: Int, page: Int)
    case addComment(token: String,boardId: Int, parentId: Int, contents: String)
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
        case .addPhoto:
            return .post
        case .addPost:
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
        case .reportBoard:
            return .post
        case .getAllComment:
            return .get
        case .addComment:
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
        case .addPhoto:
            return "/api/v1/images"
        case .addPost:
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
        case .reportBoard:
            return "/api/report"
        case .getAllComment(_, let boardId, _):
            return "/api/comment/\(boardId)/comments"
        case .addComment(_, let boardId, _, _):
            return "/api/comment/\(boardId)"
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
        case .addPhoto(_, let images):
            let base64Images = images.compactMap { $0.jpegData(compressionQuality: 1.0)?.base64EncodedString() }
            let requestModel = uploadImageRequestBody(files: base64Images)
            return .images(images)
        case .addPost(_, let title, let category, let contents, let imageId):
            let requestBody = CreatePostRequestBody(title: title, category: category, contents: contents, imageID: imageId)
            return .body(requestBody)
        case .deleteBoard(_, let boardId):
            return .query(boardId)
        case .requestWritePage:
            return .none
        case .saveHeart(_, let boardId):
            let requestModel = heartRequestBody(boardID: boardId)
            return .body(requestModel)
        case .deleteHeart(_, let boardId):
            let requestModel = heartRequestBody(boardID: boardId)
            return .body(requestModel)
        case .mostPopularBoard:
            return .none
        case .deleteScrap(_, let boardId):
            let requestModel = heartRequestBody(boardID: boardId)
            return .body(requestModel)
        case .saveScrap(_, let boardId):
            let requestModel = heartRequestBody(boardID: boardId)
            return .body(requestModel)
        case .searchBoard(_, let query, let page, let standard):
            let requestModel = SearchBoardRequestBody(q: query, page: page, standard: standard)
            return .query(requestModel)
        case .reportBoard(_, let boardId, let contents):
            let requestModel = ReportBoardRequestBody(boardID: boardId, contents: contents)
            return .body(requestModel)
        case .getAllComment(_, _, let page):
            let requestModel = allCommentRequestBody(page: page)
            return .query(requestModel)
        case .addComment(_, _, let parentId, let content):
            let requestModel = addCommentRequestBody(parentId: parentId, content: content)
            return .body(requestModel)
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
        case .addPhoto(let token, _):
            return ["Authorization": "Bearer \(token)"]
        case .addPost(let token, _, _, _, _):
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
        case .reportBoard(let token, _, _):
            return ["Authorization": "Bearer \(token)"]
        case .getAllComment(let token, _, _):
            return ["Authorization": "Bearer \(token)"]
        case .addComment(let token, _, _, _):
            return ["Authorization": "Bearer \(token)"]
        }
    }
}
