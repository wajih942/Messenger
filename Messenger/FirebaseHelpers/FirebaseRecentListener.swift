//
//  FirebaseRecentListener.swift
//  Messenger
//
//  Created by wajih on 9/2/22.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirebaseRecentListener {
    /*
    A singleton should be used when managing access to a resource which is shared by the entire application, and it would be destructive to potentially have multiple instances of the same class. Making sure that access to shared resources thread safe is one very good example of where this kind of pattern can be vital.*/
    static let shared = FirebaseRecentListener()
    
    private init(){}
    
    func downloadRecentChatsFromFireStore(completion:@escaping(_ allRecents:[RecentChat])->Void){
        FirebaseReference(.Recent).whereField(kSENDERID, isEqualTo: User.currentId).addSnapshotListener { querySnapshot, error in
            var recentChats : [RecentChat] = []
            guard let documents = querySnapshot?.documents else {
                print("no documents for recent chats")
                return
            }
            
            let allRecents = documents.compactMap { queryDocumentSnapshot ->
                RecentChat? in
                return try? queryDocumentSnapshot.data(as:RecentChat.self)
            }
            for recent in allRecents{
                if recent.lastMessage != ""{
                    recentChats.append(recent)
                }
            }
            recentChats.sorted(by: {$0.date! > $1.date!})
            completion(recentChats)
        }
    }
    func resetRecentCounter(chatRoomId:String){
        FirebaseReference(.Recent).whereField(kCHATROOMID, isEqualTo: chatRoomId).whereField(kSENDERID, isEqualTo: User.currentId).getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else{
                print("no documents for recent")
                return
            }
            let allRecents = documents.compactMap { queryDocumentSnapshot in
                return try? queryDocumentSnapshot.data(as: RecentChat.self)
            }
            if allRecents.count > 0{
                self.clearUnreadCounter(recent: allRecents.first!)
            }
        }
    }
    
    func clearUnreadCounter(recent:RecentChat){
        var newRecent = recent
        newRecent.unreadCounter = 0
        self.saveRecent(newRecent)
    }
    
    func saveRecent(_ recent : RecentChat){
        do {
            try FirebaseReference(.Recent).document(recent.id).setData(from: recent)
        } catch  {
            print("Error saving recent chat ", error.localizedDescription)
        }
    }
    func deleteRecent(_ recent : RecentChat){
        FirebaseReference(.Recent).document(recent.id).delete()
    }
}
