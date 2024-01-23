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
    
    func createChannel(with channelName: String, isProject: Bool) {
        let channel = Channel(name: channelName, isProject: isProject)
        ChannelListener.addDocument(data: channel.representation) { error in
            if let error = error {
                print("Error saving Channel: \(error.localizedDescription)")
            }
        }
    }
//    func createChannel(with channelName: String) {
//        let channel = Channel(name: channelName)
//        ChannelListener.addDocument(data: channel.representation) { error in
//            if let error = error {
//                print("Error saving Channel: \(error.localizedDescription)")
//            }
//        }
//    }
    
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
