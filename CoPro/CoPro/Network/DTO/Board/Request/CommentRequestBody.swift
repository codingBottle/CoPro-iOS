//
//  allCommentRequestBody.swift
//  CoPro
//
//  Created by 문인호 on 2/6/24.
//

struct allCommentRequestBody: Encodable {
    let page: Int
}

struct addCommentRequestBody: Encodable {
    let parentId: Int
    let content: String
}
