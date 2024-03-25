//
//  DeleteAccountDTO.swift
//  CoPro
//
//  Created by 박신영 on 3/18/24.
//

import Foundation

// MARK: - DeleteAccountDTO
struct DeleteAccountDTO: Codable {
    let statusCode: Int
    let message: String
    let data: DeleteAccountDataClass
}

// MARK: - DataClass
struct DeleteAccountDataClass: Codable {
    let email: String
}
