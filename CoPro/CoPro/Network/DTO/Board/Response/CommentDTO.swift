//
//  CommentDTO.swift
//  CoPro
//
//  Created by 문인호 on 2/6/24.
//

import Foundation

// MARK: - CommentDTO
struct CommentDTO: Codable {
    let statusCode: Int
    let message: String
    let data: CommentDataModel
}

// MARK: - DataClass
struct CommentDataModel: Codable {
    let content: [ContentElement]
    let pageable: Pageable
    let totalPages, totalElements: Int
    let last: Bool
    let size, number: Int
    let sort: Sort
    let numberOfElements: Int
    let first, empty: Bool
}

// MARK: - ContentElement
struct ContentElement: Codable {
    let parentID, commentID: Int
    let content: String
    let createAt: String
    let writer: Writer?
    let children: [ContentElement]

    enum CodingKeys: String, CodingKey {
        case parentID = "parentId"
        case commentID = "commentId"
        case content, createAt, writer, children
    }
}

// MARK: - Writer
struct Writer: Codable {
    let nickName, occupation: String
}
