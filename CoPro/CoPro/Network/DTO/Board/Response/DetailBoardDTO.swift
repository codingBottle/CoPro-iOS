//
//  DetailBoardDTO.swift
//  CoPro
//
//  Created by 문인호 on 1/16/24.
//

import Foundation

// MARK: - DetailBoardDTO
// 상세페이지, 수정, 등록
struct DetailBoardDTO: Codable {
    let statusCode: Int
        let message: String
        let data: BoardData
    }

struct BoardData: Codable {
   let boardId: Int
   let title, createAt: String
   let category, contents, part,tag: String?
   let count: Int
   let heart: Int
   let imageUrl: [String]?
   let nickName: String?
   let occupation: String?
   let isHeart: Bool
   let isScrap: Bool
   let commentCount: Int
   let email: String
   let picture: String
}
