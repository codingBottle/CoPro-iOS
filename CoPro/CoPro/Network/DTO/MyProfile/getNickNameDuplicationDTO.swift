//
//  getNickNameDuplicationDTO.swift
//  CoPro
//
//  Created by 박신영 on 2/11/24.
//

import Foundation

// MARK: - getNickNameDuplicationDTO
struct getNickNameDuplicationDTO: Codable {
    let statusCode: Int
    let message: String
    let data: Bool
}
