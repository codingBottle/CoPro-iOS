//
//  SearchBoardRequestBody.swift
//  CoPro
//
//  Created by 문인호 on 1/17/24.
//

struct SearchBoardRequestBody: Encodable {
    let q: String
    let page: Int
    let standard: String
}
