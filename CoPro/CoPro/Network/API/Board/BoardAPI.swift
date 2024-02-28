//
//  BoardAPI.swift
//  CoPro
//
//  Created by 문인호 on 1/16/24.
//

import Foundation

import Alamofire
import UIKit

final class BoardAPI: BaseAPI {
    static let shared = BoardAPI()
    
    private override init() {}
}

extension BoardAPI {
    // 1. 전체 게시물 조회
    
    public func getAllBoard(token: String, category: String, page: Int, standard: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.getAllBoard(token: token, category: category, page: page, standard: standard)).responseData { response in
               if let statusCode = response.response?.statusCode {
                           if statusCode == 401 {
                               // 토큰 재요청 함수 호출
                               LoginAPI.shared.refreshAccessToken { result in
                                   switch result {
                                   case .success(let loginDTO):
                                       print("토큰 재발급 성공: \(loginDTO)")
                                       
                                       DispatchQueue.main.async {
                                           self.AFManager.request(BoardRouter.getAllBoard(token: loginDTO.data.accessToken, category: category, page: page, standard: standard)).responseData { response in
                                               self.disposeNetwork(response,
                                                                   dataModel: BoardDTO.self,
                                                                   completion: completion)
                                               
                                           }
                                       }
                                   case .failure(let error):
                                       print("토큰 재발급 실패: \(error)")
                                   }
                               }
                           } else {
                               // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                               self.disposeNetwork(response, dataModel: BoardDTO.self, completion: completion)
                           }
                       } else {
                           // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
                           self.disposeNetwork(response, dataModel: BoardDTO.self, completion: completion)
                       }
           }
    }
    
    // 2. 게시글 상세보기
    
    public func getDetailBoard(token: String,
                               boardId: Int,
                               completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.getDetailBoard(token: token, boardId: boardId)).responseData { response in
            if let statusCode = response.response?.statusCode {
                        if statusCode == 401 {
                            // 토큰 재요청 함수 호출
                            LoginAPI.shared.refreshAccessToken { result in
                                switch result {
                                case .success(let loginDTO):
                                    print("토큰 재발급 성공: \(loginDTO)")
                                    
                                    DispatchQueue.main.async {
                                        self.AFManager.request(BoardRouter.getDetailBoard(token: loginDTO.data.accessToken, boardId: boardId)).responseData { response in
                                            self.disposeNetwork(response,
                                                                dataModel: DetailBoardDTO.self,
                                                                completion: completion)
                                            
                                        }
                                    }
                                case .failure(let error):
                                    print("토큰 재발급 실패: \(error)")
                                }
                            }
                        } else {
                            // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                            self.disposeNetwork(response, dataModel: DetailBoardDTO.self, completion: completion)
                        }
                    } else {
                        // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
                        self.disposeNetwork(response, dataModel: DetailBoardDTO.self, completion: completion)
                    }
        }
    }
    
    
    // 3. 게시글 수정하기
    
    
    // 게시글 신고하기
    
    public func reportBoard(token: String, boardId: Int,contents: String,                         completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.reportBoard(token: token, boardId: boardId, contents: contents)).responseData {  response in
            if let statusCode = response.response?.statusCode {
                        if statusCode == 401 {
                            // 토큰 재요청 함수 호출
                            LoginAPI.shared.refreshAccessToken { result in
                                switch result {
                                case .success(let loginDTO):
                                    print("토큰 재발급 성공: \(loginDTO)")
                                    
                                    DispatchQueue.main.async {
                                        self.AFManager.request(BoardRouter.reportBoard(token: loginDTO.data.accessToken, boardId: boardId, contents: contents)).responseData { response in
                                            self.disposeNetwork(response,
                                                                dataModel: VoidDTO.self,
                                                                completion: completion)
                                            
                                        }
                                    }
                                case .failure(let error):
                                    print("토큰 재발급 실패: \(error)")
                                }
                            }
                        } else {
                            // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                            self.disposeNetwork(response, dataModel: VoidDTO.self, completion: completion)
                        }
                    } else {
                        // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
                        self.disposeNetwork(response, dataModel: VoidDTO.self, completion: completion)
                    }
        }
    }
    
    // 4. 게시글 추가하기
    
    public func addPost(token: String, title: String, category: String, contents: String, imageId: [Int],                         completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.addPost(token: token, title: title, category: category, contents: contents, imageid: imageId)).responseData { response in
            if let statusCode = response.response?.statusCode {
                        if statusCode == 401 {
                            // 토큰 재요청 함수 호출
                            LoginAPI.shared.refreshAccessToken { result in
                                switch result {
                                case .success(let loginDTO):
                                    print("토큰 재발급 성공: \(loginDTO)")
                                    
                                    DispatchQueue.main.async {
                                        self.AFManager.request(BoardRouter.addPost(token: loginDTO.data.accessToken, title: title, category: category, contents: contents, imageid: imageId)).responseData { response in
                                            self.disposeNetwork(response,
                                                                dataModel: DetailBoardDTO.self,
                                                                completion: completion)
                                            
                                        }
                                    }
                                case .failure(let error):
                                    print("토큰 재발급 실패: \(error)")
                                }
                            }
                        } else {
                            // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                            self.disposeNetwork(response, dataModel: DetailBoardDTO.self, completion: completion)
                        }
                    } else {
                        // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
                        self.disposeNetwork(response, dataModel: DetailBoardDTO.self, completion: completion)
                    }
        }
    }
    
    public func addProjectPost(token: String, title: String, category: String, contents: String, imageId: [Int], tag: String, part: String,                         completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.addProjectPost(token: token, title: title, category: category, contents: contents, part: part, tag: tag, imageid: imageId)).responseData { response in
            if let statusCode = response.response?.statusCode {
                        if statusCode == 401 {
                            // 토큰 재요청 함수 호출
                            LoginAPI.shared.refreshAccessToken { result in
                                switch result {
                                case .success(let loginDTO):
                                    print("토큰 재발급 성공: \(loginDTO)")
                                    
                                    DispatchQueue.main.async {
                                        self.AFManager.request(BoardRouter.addProjectPost(token: loginDTO.data.accessToken, title: title, category: category, contents: contents, part: part, tag: tag, imageid: imageId)).responseData { response in
                                            self.disposeNetwork(response,
                                                                dataModel: DetailBoardDTO.self,
                                                                completion: completion)
                                            
                                        }
                                    }
                                case .failure(let error):
                                    print("토큰 재발급 실패: \(error)")
                                }
                            }
                        } else {
                            // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                            self.disposeNetwork(response, dataModel: DetailBoardDTO.self, completion: completion)
                        }
                    } else {
                        // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
                        self.disposeNetwork(response, dataModel: DetailBoardDTO.self, completion: completion)
                    }
        }
    }
    
    public func editProjectPost(token: String, boardId: Int, title: String, category: String, contents: String, imageId: [Int], tag: String, part: String,                         completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.editProjectPost(token: token, boardId: boardId, title: title, Category: category, Content: contents, part: part, tag: tag, imageId: imageId)).responseData { response in
            if let statusCode = response.response?.statusCode {
                        if statusCode == 401 {
                            // 토큰 재요청 함수 호출
                            LoginAPI.shared.refreshAccessToken { result in
                                switch result {
                                case .success(let loginDTO):
                                    print("토큰 재발급 성공: \(loginDTO)")
                                    
                                    DispatchQueue.main.async {
                                        self.AFManager.request(BoardRouter.editProjectPost(token: token, boardId: boardId, title: title, Category: category, Content: contents, part: part, tag: tag, imageId: imageId)).responseData { response in
                                            self.disposeNetwork(response,
                                                                dataModel: DetailBoardDTO.self,
                                                                completion: completion)
                                            
                                        }
                                    }
                                case .failure(let error):
                                    print("토큰 재발급 실패: \(error)")
                                }
                            }
                        } else {
                            // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                            self.disposeNetwork(response, dataModel: DetailBoardDTO.self, completion: completion)
                        }
                    } else {
                        // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
                        self.disposeNetwork(response, dataModel: DetailBoardDTO.self, completion: completion)
                    }
        }
    }
    
    public func editPost(token: String, boardId: Int,title: String, category: String, contents: String, imageId: [Int], tag: String, part: String,                         completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.editBoard(token: token, boardId: boardId, title: title, Category: category, Content: contents, part: part, tag: tag, imageId: imageId)).responseData { response in
            if let statusCode = response.response?.statusCode {
                        if statusCode == 401 {
                            // 토큰 재요청 함수 호출
                            LoginAPI.shared.refreshAccessToken { result in
                                switch result {
                                case .success(let loginDTO):
                                    print("토큰 재발급 성공: \(loginDTO)")
                                    
                                    DispatchQueue.main.async {
                                        self.AFManager.request(BoardRouter.editBoard(token: token, boardId: boardId, title: title, Category: category, Content: contents, part: part, tag: tag, imageId: imageId)).responseData { response in
                                            self.disposeNetwork(response,
                                                                dataModel: DetailBoardDTO.self,
                                                                completion: completion)
                                            
                                        }
                                    }
                                case .failure(let error):
                                    print("토큰 재발급 실패: \(error)")
                                }
                            }
                        } else {
                            // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                            self.disposeNetwork(response, dataModel: DetailBoardDTO.self, completion: completion)
                        }
                    } else {
                        // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
                        self.disposeNetwork(response, dataModel: DetailBoardDTO.self, completion: completion)
                    }
        }
    }
    
    public func addPhoto(token: String, imageId: [UIImage],                         completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.addPhoto(token: token, images: imageId)).responseData { response in
            if let statusCode = response.response?.statusCode {
                        if statusCode == 401 {
                            // 토큰 재요청 함수 호출
                            LoginAPI.shared.refreshAccessToken { result in
                                switch result {
                                case .success(let loginDTO):
                                    print("토큰 재발급 성공: \(loginDTO)")
                                    
                                    DispatchQueue.main.async {
                                        self.AFManager.request(BoardRouter.addPhoto(token: loginDTO.data.accessToken, images: imageId)).responseData { response in
                                            self.disposeNetwork(response,
                                                                dataModel: ImageUploadDTO.self,
                                                                completion: completion)
                                            
                                        }
                                    }
                                case .failure(let error):
                                    print("토큰 재발급 실패: \(error)")
                                }
                            }
                        } else {
                            // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                            self.disposeNetwork(response, dataModel: ImageUploadDTO.self, completion: completion)
                        }
                    } else {
                        // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
                        self.disposeNetwork(response, dataModel: ImageUploadDTO.self, completion: completion)
                    }
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
            if let statusCode = response.response?.statusCode {
                        if statusCode == 401 {
                            // 토큰 재요청 함수 호출
                            LoginAPI.shared.refreshAccessToken { result in
                                switch result {
                                case .success(let loginDTO):
                                    print("토큰 재발급 성공: \(loginDTO)")
                                    
                                    DispatchQueue.main.async {
                                        self.AFManager.request(BoardRouter.saveHeart(token: loginDTO.data.accessToken, boardId: boardID)).responseData { response in
                                            self.disposeNetwork(response,
                                                                dataModel: DetailHeartDataModel.self,
                                                                completion: completion)
                                            
                                        }
                                    }
                                case .failure(let error):
                                    print("토큰 재발급 실패: \(error)")
                                }
                            }
                        } else {
                            // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                            self.disposeNetwork(response, dataModel: DetailHeartDataModel.self, completion: completion)
                        }
                    } else {
                        // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
                        self.disposeNetwork(response, dataModel: DetailHeartDataModel.self, completion: completion)
                    }
        }
    }
    // 8. 좋아요 삭제
    public func deleteHeart(token: String, boardID: Int, completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.deleteHeart(token: token, boardId: boardID)).responseData { response in
            if let statusCode = response.response?.statusCode {
                        if statusCode == 401 {
                            // 토큰 재요청 함수 호출
                            LoginAPI.shared.refreshAccessToken { result in
                                switch result {
                                case .success(let loginDTO):
                                    print("토큰 재발급 성공: \(loginDTO)")
                                    
                                    DispatchQueue.main.async {
                                        self.AFManager.request(BoardRouter.deleteHeart(token: loginDTO.data.accessToken, boardId: boardID)).responseData { response in
                                            self.disposeNetwork(response,
                                                                dataModel: DetailHeartDataModel.self,
                                                                completion: completion)
                                            
                                        }
                                    }
                                case .failure(let error):
                                    print("토큰 재발급 실패: \(error)")
                                }
                            }
                        } else {
                            // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                            self.disposeNetwork(response, dataModel: DetailHeartDataModel.self, completion: completion)
                        }
                    } else {
                        // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
                        self.disposeNetwork(response, dataModel: DetailHeartDataModel.self, completion: completion)
                    }
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
    public func deleteScrap(token: String, boardID: Int, completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.deleteScrap(token: token, boardId: boardID)).responseData { response in
            if let statusCode = response.response?.statusCode {
                        if statusCode == 401 {
                            // 토큰 재요청 함수 호출
                            LoginAPI.shared.refreshAccessToken { result in
                                switch result {
                                case .success(let loginDTO):
                                    print("토큰 재발급 성공: \(loginDTO)")
                                    
                                    DispatchQueue.main.async {
                                        self.AFManager.request(BoardRouter.deleteScrap(token: loginDTO.data.accessToken, boardId: boardID)).responseData { response in
                                            self.disposeNetwork(response,
                                                                dataModel: VoidDTO.self,
                                                                completion: completion)
                                            
                                        }
                                    }
                                case .failure(let error):
                                    print("토큰 재발급 실패: \(error)")
                                }
                            }
                        } else {
                            // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                            self.disposeNetwork(response, dataModel: VoidDTO.self, completion: completion)
                        }
                    } else {
                        // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
                        self.disposeNetwork(response, dataModel: VoidDTO.self, completion: completion)
                    }
        }
    }
    
    // 11. 스크랩 추가
    public func saveScrap(token: String, boardID: Int, completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.saveScrap(token: token, boardId: boardID)).responseData { response in
            if let statusCode = response.response?.statusCode {
                        if statusCode == 401 {
                            // 토큰 재요청 함수 호출
                            LoginAPI.shared.refreshAccessToken { result in
                                switch result {
                                case .success(let loginDTO):
                                    print("토큰 재발급 성공: \(loginDTO)")
                                    
                                    DispatchQueue.main.async {
                                        self.AFManager.request(BoardRouter.saveScrap(token: loginDTO.data.accessToken, boardId: boardID)).responseData { response in
                                            self.disposeNetwork(response,
                                                                dataModel: VoidDTO.self,
                                                                completion: completion)
                                            
                                        }
                                    }
                                case .failure(let error):
                                    print("토큰 재발급 실패: \(error)")
                                }
                            }
                        } else {
                            // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                            self.disposeNetwork(response, dataModel: VoidDTO.self, completion: completion)
                        }
                    } else {
                        // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
                        self.disposeNetwork(response, dataModel: VoidDTO.self, completion: completion)
                    }
        }
    }
    
    // 12. 게시물 검색
    public func searchBoard(token: String, query: String, page: Int, standard: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.searchBoard(token: token, query: query, page: page, standard: standard)).responseData { response in
            if let statusCode = response.response?.statusCode {
                        if statusCode == 401 {
                            // 토큰 재요청 함수 호출
                            LoginAPI.shared.refreshAccessToken { result in
                                switch result {
                                case .success(let loginDTO):
                                    print("토큰 재발급 성공: \(loginDTO)")
                                    
                                    DispatchQueue.main.async {
                                        self.AFManager.request(BoardRouter.searchBoard(token: loginDTO.data.accessToken, query: query, page: page, standard: standard)).responseData { response in
                                            self.disposeNetwork(response,
                                                                dataModel: BoardDTO.self,
                                                                completion: completion)
                                            
                                        }
                                    }
                                case .failure(let error):
                                    print("토큰 재발급 실패: \(error)")
                                }
                            }
                        } else {
                            // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                            self.disposeNetwork(response, dataModel: BoardDTO.self, completion: completion)
                        }
                    } else {
                        // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
                        self.disposeNetwork(response, dataModel: BoardDTO.self, completion: completion)
                    }
        }
    }
    
    // 13. 댓글 가져오기
    public func getAllComment(token: String, boardId: Int, page: Int, completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.getAllComment(token: token, boardId: boardId, page: page)).responseData {  response in
            if let statusCode = response.response?.statusCode {
                        if statusCode == 401 {
                            // 토큰 재요청 함수 호출
                            LoginAPI.shared.refreshAccessToken { result in
                                switch result {
                                case .success(let loginDTO):
                                    print("토큰 재발급 성공: \(loginDTO)")
                                    
                                    DispatchQueue.main.async {
                                        self.AFManager.request(BoardRouter.getAllComment(token: loginDTO.data.accessToken, boardId: boardId, page: page)).responseData { response in
                                            self.disposeNetwork(response,
                                                                dataModel: CommentDTO.self,
                                                                completion: completion)
                                            
                                        }
                                    }
                                case .failure(let error):
                                    print("토큰 재발급 실패: \(error)")
                                }
                            }
                        } else {
                            // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                            self.disposeNetwork(response, dataModel: CommentDTO.self, completion: completion)
                        }
                    } else {
                        // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
                        self.disposeNetwork(response, dataModel: CommentDTO.self, completion: completion)
                    }
        }
    }
    
    // 14. 댓글 작성하기
    public func addComment(token: String, boardId: Int, parentId: Int, content: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.addComment(token: token, boardId: boardId, parentId: parentId, contents: content)).responseData { response in
            if let statusCode = response.response?.statusCode {
                        if statusCode == 401 {
                            // 토큰 재요청 함수 호출
                            LoginAPI.shared.refreshAccessToken { result in
                                switch result {
                                case .success(let loginDTO):
                                    print("토큰 재발급 성공: \(loginDTO)")
                                    
                                    DispatchQueue.main.async {
                                        self.AFManager.request(BoardRouter.addComment(token: loginDTO.data.accessToken, boardId: boardId, parentId: parentId, contents: content)).responseData { response in
                                            self.disposeNetwork(response,
                                                                dataModel: CommentDTO.self,
                                                                completion: completion)
                                            
                                        }
                                    }
                                case .failure(let error):
                                    print("토큰 재발급 실패: \(error)")
                                }
                            }
                        } else {
                            // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                            self.disposeNetwork(response, dataModel: CommentDTO.self, completion: completion)
                        }
                    } else {
                        // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
                        self.disposeNetwork(response, dataModel: CommentDTO.self, completion: completion)
                    }
        }
    }
    
    public func deleteComment(token: String, boardId: Int, completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.deleteComment(token: token, boardId: boardId)).responseData { response in
            if let statusCode = response.response?.statusCode {
                        if statusCode == 401 {
                            // 토큰 재요청 함수 호출
                            LoginAPI.shared.refreshAccessToken { result in
                                switch result {
                                case .success(let loginDTO):
                                    print("토큰 재발급 성공: \(loginDTO)")
                                    
                                    DispatchQueue.main.async {
                                        self.AFManager.request(BoardRouter.deleteComment(token: loginDTO.data.accessToken, boardId: boardId)).responseData { response in
                                            self.disposeNetwork(response,
                                                                dataModel: VoidDTO.self,
                                                                completion: completion)
                                            
                                        }
                                    }
                                case .failure(let error):
                                    print("토큰 재발급 실패: \(error)")
                                }
                            }
                        } else {
                            // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                            self.disposeNetwork(response, dataModel: VoidDTO.self, completion: completion)
                        }
                    } else {
                        // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
                        self.disposeNetwork(response, dataModel: VoidDTO.self, completion: completion)
                    }
        }
    }
    public func editComment(token: String, boardId: Int, content: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        AFManager.request(BoardRouter.editComment(token: token, boardId: boardId, contents: content)).responseData { response in
            if let statusCode = response.response?.statusCode {
                        if statusCode == 401 {
                            // 토큰 재요청 함수 호출
                            LoginAPI.shared.refreshAccessToken { result in
                                switch result {
                                case .success(let loginDTO):
                                    print("토큰 재발급 성공: \(loginDTO)")
                                    
                                    DispatchQueue.main.async {
                                        self.AFManager.request(BoardRouter.editComment(token: loginDTO.data.accessToken, boardId: boardId, contents: content)).responseData { response in
                                            self.disposeNetwork(response,
                                                                dataModel: EditCommentDTO.self,
                                                                completion: completion)
                                            
                                        }
                                    }
                                case .failure(let error):
                                    print("토큰 재발급 실패: \(error)")
                                }
                            }
                        } else {
                            // 상태 코드가 401이 아닌 경우, 결과를 컴플리션 핸들러로 전달
                            self.disposeNetwork(response, dataModel: EditCommentDTO.self, completion: completion)
                        }
                    } else {
                        // 상태 코드를 가져오는데 실패한 경우, 결과를 컴플리션 핸들러로 전달
                        self.disposeNetwork(response, dataModel: EditCommentDTO.self, completion: completion)
                    }
        }
    }
}

