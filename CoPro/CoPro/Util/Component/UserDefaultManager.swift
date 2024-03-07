//
//  UserDefaultManager.swift
//  CoPro
//
//  Created by 박신영 on 12/27/23.
//

import Foundation

struct UserDefaultManager {
    static var displayName: String {
        get {
            UserDefaults.standard.string(forKey: "DisplayName") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "DisplayName")
        }
    }
}
