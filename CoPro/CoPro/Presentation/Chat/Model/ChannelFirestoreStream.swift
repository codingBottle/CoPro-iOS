//
//  ChannelFirestoreStream.swift
//  CoPro
//
//  Created by 박신영 on 12/27/23.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift

class ChannelFirestoreStream {
    private let storage = Storage.storage().reference()
    let firestoreDatabase = Firestore.firestore()
    var listener: ListenerRegistration?
    lazy var ChannelListener: CollectionReference = {
        return firestoreDatabase.collection("channels")
    }()
    
   
   /**
    1. 송신자 / 송신자이미지 / 송신자 직군 / 송신자 이멩
    2. 수신자 / 수신자이미지 / 수신자 직군 / 수신자 이메일
    */
   
   func createChannel(channelId: String, sender: String, senderJobTitle: String, senderProfileImage: String, senderEmail: String, receiver: String, receiverJobTitle: String, receiverProfileImage: String, receiverEmail: String, completion: @escaping (Error?) -> Void) {
       // Firestore 참조 생성
       let db = Firestore.firestore()
       
       // 'channelId'가 일치하는 문서 조회
      db.collection("channels")
        .whereField("channelId", isEqualTo: channelId)
        .getDocuments { (querySnapshot, error) in
           if let error = error {
               // Firestore 에러 처리
               completion(error)
           } else if let querySnapshot = querySnapshot, !querySnapshot.documents.isEmpty {
               // 문서가 이미 존재하는 경우 오류 반환
              print("제발")
              
               completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Channel already exists"]))
           } else {
               // 새로운 채널 생성
              let channel = Channel(channelId: channelId, sender: sender, senderJobTitle: senderJobTitle, senderProfileImage: senderProfileImage, senderEmail: senderEmail, receiver: receiver, receiverJobTitle: receiverJobTitle, receiverProfileImage: receiverProfileImage, receiverEmail: receiverEmail)
               self.ChannelListener.addDocument(data: channel.representation) { error in
                   if let error = error {
                       print("Error saving Channel: \(error.localizedDescription)")
                   }
                   print("개설 끝")
                  completion(nil)
               }
           }
       }
   }


   
   
    // Read & Update
    func subscribe(completion: @escaping (Result<[(Channel, DocumentChangeType)], Error>) -> Void) {
        ChannelListener.addSnapshotListener { snaphot, error in
            guard let snapshot = snaphot else {
                completion(.failure(error!))
                return
            }
            
            let result = snapshot.documentChanges
                .filter { Channel($0.document) != nil }
                .compactMap { (Channel($0.document)!, $0.type) }
            
            completion(.success(result))
        }
    }
    
    func deleteChannel(_ channel: Channel) {
            // 삭제할 문서의 참조를 가져옵니다.
        let channelRef = firestoreDatabase.collection("channels").document(channel.id ?? "")

            // 문서를 삭제합니다.
            channelRef.delete { error in
                if let error = error {
                    print("Error deleting channel: \(error)")
                } else {
                    print("Channel successfully deleted")
                }
            }
        }
    
    func removeListener() {
        listener?.remove()
    }
}
