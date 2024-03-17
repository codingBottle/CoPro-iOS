//
//  MyWrittenCommentDTO.swift
//  CoPro
//
//  Created by 박신영 on 2/2/24.
//


import Foundation

// MARK: - MyWrittenCommentDTO
struct MyWrittenCommentDTO: Codable {
    let statusCode: Int
    let message: String
    let data: MyWrittenCommentData
}

// MARK: - MyWrittenCommentData
struct MyWrittenCommentData: Codable {
    let totalPages, totalElements: Int
    let pageable: MyWrittenCommentPageable
    let first, last: Bool
    let size: Int
    let content: [MyWrittenCommentContent]
    let number: Int
    let sort: MyWrittenCommentSort
    let numberOfElements: Int
    let empty: Bool
}

// MARK: - Content
struct MyWrittenCommentContent: Codable {
    let parentID, commentID, boardID: Int
    let content, createAt: String
    let writer: MyWrittenCommentWriter

    enum CodingKeys: String, CodingKey {
        case parentID = "parentId"
        case commentID = "commentId"
        case boardID = "boardId"
        case content, createAt, writer
    }
}

// MARK: - Writer
struct MyWrittenCommentWriter: Codable {
    let nickName, occupation: String
}

// MARK: - Pageable
struct MyWrittenCommentPageable: Codable {
    let pageNumber, pageSize, offset: Int
    let sort: MyWrittenCommentSort
    let paged, unpaged: Bool
}

// MARK: - Sort
struct MyWrittenCommentSort: Codable {
    let sorted, empty, unsorted: Bool
}

