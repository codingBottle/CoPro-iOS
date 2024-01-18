//
//  VoidDTO.swift
//  CoPro
//
//  Created by 문인호 on 1/16/24.
//

import Foundation

// MARK: - VoidDTO
// 게시물 삭제, 작성페이지 요청, 좋아요 삭제, 좋아요 등록, 
struct VoidDTO: Codable {
    let statusCode: Int
    let message, data: String?
}
