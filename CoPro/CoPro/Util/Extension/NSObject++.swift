//
//  NSObject++.swift
//  CoPro
//
//  Created by 박신영 on 12/27/23.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
