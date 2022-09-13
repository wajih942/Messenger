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
    private init(){}
    //MARK: - Add, Update ,Delete
    func addMessage(_ message: LocalMessage,memberId:String){
        do {
            let _ = try FirebaseReference(.Messages).document(memberId).collection(message.chatRoomId).document(message.id).setData(from: message)
        } catch  {
            print("error saving message ",error.localizedDescription)
        }
    }
}
