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
   let occupation: String
   let isProject: Bool  // 추가된 프로퍼티
   let profileImage: String
   let unreadCount: Int
   
   init(id: String? = nil, name: String, isProject: Bool = false, profileImage: String, occupation: String, unreadCount: Int) {
      self.id = id
      self.name = name
      self.isProject = isProject
      self.profileImage = profileImage
      self.occupation = occupation
      self.unreadCount = unreadCount
   }
   
   init?(_ document: QueryDocumentSnapshot) {
      let data = document.data()
      
      guard let name = data["name"] as? String,
            let isProject = data["isProject"] as? Bool,
            let profileImage = data["profileImage"] as? String,
            let occupation = data["occupation"] as? String,
            let unreadCount = data["unreadCount"] as? Int
      else {
         return nil
      }
      
      id = document.documentID
      self.name = name
      self.isProject = isProject // 추가된 부분
      self.profileImage = profileImage
      self.occupation = occupation
      self.unreadCount = unreadCount
   }
}

extension Channel: DatabaseRepresentation {
    var representation: [String: Any] {
       var rep: [String : Any] = ["name": name, "isProject": isProject, "profileImage": profileImage, "occupation": occupation, "unreadCount": unreadCount]
        
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
