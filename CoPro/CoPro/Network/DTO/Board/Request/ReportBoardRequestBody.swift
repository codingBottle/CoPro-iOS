//
//  ReportBoardRequestBody.swift
//  CoPro
//
//  Created by 문인호 on 1/17/24.
//

import Foundation

// MARK: - ReportBoardRequestBody
struct ReportBoardRequestBody: Codable {
    let boardID: Int
    let contents: String

    enum CodingKeys: String, CodingKey {
        case boardID = "boardId"
        case contents
    }
}
