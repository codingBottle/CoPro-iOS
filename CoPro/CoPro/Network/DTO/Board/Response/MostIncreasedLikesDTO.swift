//
//  MostIncreasedLikesDTO.swift
//  CoPro
//
//  Created by 문인호 on 1/16/24.
//

import Foundation

// MARK: - MostIncreasedLikesDTO
struct MostIncreasedLikesDTO: Codable {
    let statusCode: Int
    let message: String
    let data: DetailBoardDTO
}
