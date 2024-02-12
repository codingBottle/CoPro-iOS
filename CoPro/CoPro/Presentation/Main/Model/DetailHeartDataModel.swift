//
//  DetailHeartDataModel.swift
//  CoPro
//
//  Created by 문인호 on 1/26/24.
//

import Foundation

// MARK: - DetailHeartDataModel
struct DetailHeartDataModel: Codable {
    let statusCode: Int
    let message: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let heart: Int
}
