//
//  BoardAPI.swift
//  CoPro
//
//  Created by 문인호 on 1/16/24.
//

import Foundation

import Alamofire

final class BoardAPI: BaseAPI {
    static let shared = BoardAPI()
    
    private override init() {}
}

extension BoardAPI {
    // 1. 전체 게시물 조회
    
    public func getAllBoard(token: String, category: String, page: Int, standard: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.getAllBoard(token: token, category: category, page: page, standard: standard)).responseData { response in
            self.disposeNetwork(response,
                                dataModel: BoardDTO.self,
                                completion: completion)
        }
    }
    
    // 2. 게시글 상세보기
    
    public func getDetailBoard(token: String,
                                    boardId: Int,
                                    completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.getDetailBoard(token: token, boardId: boardId)).responseData { response in
            self.disposeNetwork(response,
                                dataModel: DetailBoardDTO.self,
                                completion: completion)
        }
    }

    
    // 3. 게시글 수정하기
    
    public func editBoard(token: String,
                          boardId: Int, requestBody: CreateBoardRequestBody,
                                   completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.editBoard(token: token, boardId: boardId, requestBody: requestBody)).responseData { response in
            self.disposeNetwork(response,
                                dataModel: DetailBoardDTO.self,
                                completion: completion)
        }
    }
    
    // 게시글 신고하기
    
    public func reportBoard(token: String, boardId: Int,contents: String,                         completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.reportBoard(token: token, boardId: boardId, contents: contents)).responseData { response in
            self.disposeNetwork(response,
                                dataModel: VoidDTO.self,
                                completion: completion)
        }
    }
    
    // 4. 게시글 추가하기
    
    public func addBoard(token: String, requestBody: CreateBoardRequestBody,                         completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.addBoard(token: token, requestBody: requestBody)).responseData { response in
            self.disposeNetwork(response,
                                dataModel: DetailBoardDTO.self,
                                completion: completion)
            
        }
    }
    
    // 5. 게시글 삭제하기
    
    public func deleteBoard(token: String, boardId: Int,
                             completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.deleteBoard(token: token, boardId: boardId)).responseData { response in
            self.disposeNetwork(response,
                                dataModel: VoidDTO.self,
                                completion: completion)
        }
    }
    
    // 6. 게시글 추가 페이지 요청하기 ??
    public func requestWritePage(token: String, category: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.requestWritePage(token: token, category: category)).responseData { response in
            self.disposeNetwork(response,
                                dataModel: VoidDTO.self,
                                completion: completion)
        }
    }
    // 7. 좋아요 등록
    public func saveHeart(token: String, boardID: Int, completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.saveHeart(token: token, boardId: boardID)).responseData { response in
            self.disposeNetwork(response,
                                dataModel: DetailHeartDataModel.self,
                                completion: completion)
        }
    }
    // 8. 좋아요 삭제
    public func deleteHeart(token: String, boardID: Int, completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.deleteHeart(token: token, boardId: boardID)).responseData { response in
            self.disposeNetwork(response,
                                dataModel: DetailHeartDataModel.self,
                                completion: completion)
        }
    }
    // 9. 인기 글 조회
    public func mostPopularBoard(token: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.mostPopularBoard(token: token)).responseData { response in
            self.disposeNetwork(response,
                                dataModel: MostIncreasedLikesDTO.self,
                                completion: completion)
        }
    }
    // 10. 스크랩 삭제
    public func deleteScrap(token: String, requestBody: heartRequestBody, completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.deleteScrap(token: token, requestBody: requestBody)).responseData { response in
            self.disposeNetwork(response,
                                dataModel: VoidDTO.self,
                                completion: completion)
        }
    }
    // 11. 스크랩 추가
    public func saveScrap(token: String, requestBody: heartRequestBody, completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.saveScrap(token: token, requestBody: requestBody)).responseData { response in
            self.disposeNetwork(response,
                                dataModel: VoidDTO.self,
                                completion: completion)
            
        }
    }
    
    // 12. 게시물 검색
    public func searchBoard(token: String, query: String, page: Int, standard: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.searchBoard(token: token, query: query, page: page, standard: standard)).responseData { response in
            self.disposeNetwork(response,
                                dataModel: BoardDTO.self,
                                completion: completion)
            
        }
    }
}

