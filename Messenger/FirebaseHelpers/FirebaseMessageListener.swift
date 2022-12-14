//
//  FirebaseMessageListener.swift
//  Messenger
//
//  Created by wajih on 9/13/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FirebaseMessageListener{
    static let shared = FirebaseMessageListener()
    var newChatListener : ListenerRegistration!
    var updateChatListener : ListenerRegistration!
    private init(){}
    
    func listenForNewChats(_ documentId : String,collectionId: String,lastMessageDate: Date){
        newChatListener = FirebaseReference(.Messages).document(documentId).collection(collectionId).whereField(kDate, isGreaterThan: lastMessageDate).addSnapshotListener({ querySnapshot, error in
            guard let snapshot = querySnapshot else {
                return
            }
            for change in snapshot.documentChanges {
                if change.type == .added{
                    let result = Result{
                        try? change.document.data(as: LocalMessage.self)
                    }
                    switch result {
                    case .success(let messageObject):
                        if let message = messageObject {
                            RealmManager.shared.saveToRealm(message)
                        }else{
                            print("Document doesn't exist")
                        }
                    case .failure(let error):
                        print("Error decoding local  \(error.localizedDescription)")
                    }
                }
            }
        })
    }
    func checkForOldChats(_ documentId: String , collectionId : String){
        FirebaseReference(.Messages).document(documentId).collection(collectionId).getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("no documents for old chats")
                return
            }
            var oldMessages = documents.compactMap { queryDocumentSnapshot -> LocalMessage? in
                return try? queryDocumentSnapshot.data(as: LocalMessage.self)
            }
            oldMessages.sort(by: {$0.date < $1.date})
            for message in oldMessages {
                RealmManager.shared.saveToRealm(message)
            }
        }
        
    }
    //MARK: - Add, Update ,Delete
    func addMessage(_ message: LocalMessage,memberId:String){
        do {
            let _ = try FirebaseReference(.Messages).document(memberId).collection(message.chatRoomId).document(message.id).setData(from: message)
        } catch  {
            print("error saving message ",error.localizedDescription)
        }
    }
}
