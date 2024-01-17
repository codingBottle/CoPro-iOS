//
//  CreateBoardRequestBody.swift
//  CoPro
//
//  Created by 문인호 on 1/16/24.
//

import Foundation

// MARK: - CreateBoardRequestBody
struct CreateBoardRequestBody: Codable {
    let title, category, contents, tag: String
    let count, heart: Int
    let imageID: [String]

    enum CodingKeys: String, CodingKey {
        case title, category, contents, tag, count, heart
        case imageID = "imageId"
    }
}
