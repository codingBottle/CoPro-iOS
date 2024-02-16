//
//  CreateBoardRequestBody.swift
//  CoPro
//
//  Created by 문인호 on 1/16/24.
//

import Foundation

// MARK: - CreateBoardRequestBody
struct CreatePostRequestBody: Codable {
    let title, category, contents, part, tag: String
    let imageID: [Int]

    enum CodingKeys: String, CodingKey {
        case title, category, contents, part, tag
        case imageID = "imageId"
    }
}

struct uploadImageRequestBody: Codable {
    let files: [String]
}
