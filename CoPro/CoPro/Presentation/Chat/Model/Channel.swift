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
   let channelId: String
   let sender: String
   let senderJobTitle: String
   let senderProfileImage: String
   let senderEmail: String
   let receiver: String
   let receiverJobTitle: String
   let receiverProfileImage: String
   let receiverEmail: String

   init(id: String? = nil, channelId: String, sender: String, senderJobTitle: String, senderProfileImage: String, senderEmail: String, receiver: String, receiverJobTitle: String, receiverProfileImage: String, receiverEmail: String) {
      self.id = id
      self.channelId = channelId
      self.sender = sender
      self.senderJobTitle = senderJobTitle
      self.senderProfileImage = senderProfileImage
      self.senderEmail = senderEmail
      self.receiver = receiver
      self.receiverJobTitle = receiverJobTitle
      self.receiverProfileImage = receiverProfileImage
      self.receiverEmail = receiverEmail
   }
   
   init?(_ document: QueryDocumentSnapshot) {
      let data = document.data()
      
      guard let channelId = data["channelId"] as? String,
            let sender = data["sender"] as? String,
            let senderJobTitle = data["senderJobTitle"] as? String,
            let senderProfileImage = data["senderProfileImage"] as? String,
            let senderEmail = data["senderEmail"] as? String,
            let receiver = data["receiver"] as? String,
            let receiverJobTitle = data["receiverJobTitle"] as? String,
            let receiverProfileImage = data["receiverProfileImage"] as? String,
            let receiverEmail = data["receiverEmail"] as? String
      else {
         return nil
      }
      
      id = document.documentID
      self.channelId = channelId
      self.sender = sender
      self.senderJobTitle = senderJobTitle
      self.senderProfileImage = senderProfileImage
      self.senderEmail = senderEmail
      self.receiver = receiver
      self.receiverJobTitle = receiverJobTitle
      self.receiverProfileImage = receiverProfileImage
      self.receiverEmail = receiverEmail
   }
}

extension Channel: DatabaseRepresentation {
    var representation: [String: Any] {
       var rep: [String : Any] = ["channelId": channelId, "sender": sender, "senderJobTitle": senderJobTitle, "senderProfileImage": senderProfileImage, "senderEmail": senderEmail, "receiver": receiver, "receiverJobTitle": receiverJobTitle, "receiverProfileImage": receiverProfileImage, "receiverEmail": receiverEmail]
        
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
