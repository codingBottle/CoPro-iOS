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
   let sender: String
   let receiver: String
   let senderProfileImage: String
   let receiverProfileImage: String
   let occupation: String
//   let isProject: Bool  // 추가된 프로퍼티
   
   let unreadCount: Int

   init(id: String? = nil, sender: String, senderProfileImage: String, receiver: String, receiverProfileImage: String, occupation: String, unreadCount: Int) {
      self.id = id
      self.sender = sender
      self.receiver = receiver
      self.senderProfileImage = senderProfileImage
      self.receiverProfileImage = receiverProfileImage
      self.occupation = occupation
      self.unreadCount = unreadCount
   }
   
   init?(_ document: QueryDocumentSnapshot) {
      let data = document.data()
      
      guard let sender = data["sender"] as? String,
            let receiver = data["receiver"] as? String,
            let senderProfileImage = data["senderProfileImage"] as? String,
            let receiverProfileImage = data["receiverProfileImage"] as? String,
            let occupation = data["occupation"] as? String,
            let unreadCount = data["unreadCount"] as? Int
      else {
         return nil
      }
      
      id = document.documentID
      self.sender = sender
      self.receiver = receiver
      self.senderProfileImage = senderProfileImage
      self.receiverProfileImage = receiverProfileImage
      self.occupation = occupation
      self.unreadCount = unreadCount
   }
}

extension Channel: DatabaseRepresentation {
    var representation: [String: Any] {
       var rep: [String : Any] = ["sender": sender, "receiver": receiver, "senderProfileImage": senderProfileImage, "receiverProfileImage": receiverProfileImage, "occupation": occupation, "unreadCount": unreadCount]
        
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
        return lhs.sender < rhs.sender
    }
}
