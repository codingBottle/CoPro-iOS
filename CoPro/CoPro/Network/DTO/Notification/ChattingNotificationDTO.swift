//
//  ChattingNotificationDTO.swift
//  CoPro
//
//  Created by 박신영 on 2/20/24.
//

import Foundation

// MARK: - ChattingNotificationDTO
struct ChattingNotificationDTO: Codable {
    let statusCode: Int
    let message, data: String
}
