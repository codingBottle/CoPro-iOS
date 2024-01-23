//
//  heartRequestBody.swift
//  CoPro
//
//  Created by 문인호 on 1/16/24.
//

import Foundation

// MARK: - CreateBoardRequestBody
struct heartRequestBody: Codable {
    let boardID: Int

    enum CodingKeys: String, CodingKey {
        case boardID = "boardId"
    }
}
