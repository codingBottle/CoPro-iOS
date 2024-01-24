//
//  DetailBoardRequestBody.swift
//  CoPro
//
//  Created by 문인호 on 1/23/24.
//

import Foundation

struct DetailBoardRequestBody: Codable {
    let boardID: Int

    enum CodingKeys: String, CodingKey {
        case boardID = "boardId"
    }
}
