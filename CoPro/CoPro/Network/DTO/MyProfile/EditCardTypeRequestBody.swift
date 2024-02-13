//
//  EditCardTypeRequestBody.swift
//  CoPro
//
//  Created by 박신영 on 1/31/24.
//

import Foundation

// MARK: - EditCardTypeRequestBody
struct EditCardTypeRequestBody: Codable {
    let viewType: Int
    
    init(viewType: Int) {
        self.viewType = viewType
    }
}
