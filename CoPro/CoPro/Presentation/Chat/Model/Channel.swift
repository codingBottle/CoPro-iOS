//
//  Channel.swift
//  CoPro
//
//  Created by 박신영 on 12/27/23.
//

import Foundation
import FirebaseFirestore

struct Channel {
    var id: String?
    let name: String
    let isProject: Bool  // 추가된 프로퍼티
    
    init(id: String? = nil, name: String, isProject: Bool = false) {
        self.id = id
        self.name = name
        self.isProject = isProject
    }
    
    init?(_ document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let name = data["name"] as? String,
              let isProject = data["isProject"] as? Bool else {
            return nil
        }
        
        id = document.documentID
        self.name = name
        self.isProject = isProject // 추가된 부분
    }
}

extension Channel: DatabaseRepresentation {
    var representation: [String: Any] {
        var rep: [String : Any] = ["name": name, "isProject": isProject]
        
        if let id = id {
            rep["id"] = id
        }
        
        return rep
    }
}


extension Channel: Comparable {
    static func == (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.name < rhs.name
    }
}
