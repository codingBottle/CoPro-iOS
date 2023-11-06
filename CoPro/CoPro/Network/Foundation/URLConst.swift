//
//  URLConst.swift
//  CoPro
//
//  Created by 문인호 on 10/30/23.
//

import Foundation

struct APIConstants {
    static let contentType = "Content-Type"
    static let applicationJSON = "application/json"
}

extension APIConstants {
    
    static var defaultHeader: Dictionary<String,String> {
        [contentType: applicationJSON]
    }
}
