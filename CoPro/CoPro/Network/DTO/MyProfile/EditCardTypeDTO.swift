//
//  EditCardTypeDTO.swift
//  CoPro
//
//  Created by 박신영 on 1/31/24.
//

import Foundation

// MARK: - EditCardTypeDTO
struct EditCardTypeDTO: Codable {
    let statusCode: Int
    let message: String
    let data: Int
}
