//
//  OutgoingMessage.swift
//  Messenger
//
//  Created by wajih on 9/10/22.
//

import Foundation
import UIKit
import FirebaseFirestoreSwift

class OutgoingMessage {
    class func send(chaId:String,text:String?,photo:UIImage?,video:String?,audio:String?,audioDuration:Float=0.0,location:String?,memberIds:[String]) {
        
        let currentUser = User.currentUser!
        let message = LocalMessage()
        message.id = UUID().uuidString
        message.chatRoomId = chaId
        message.senderId = currentUser.id
        message.senderName = currentUser.username
        message.senderInitials = String(currentUser.username.first!)
        message.date = Date()
        message.status = kSENT
        
        if text != nil {
            sendTextMessage(message: message, text: text!, memberIds: memberIds)
            //send text message
            
        }
        
        //TODO: Send push notification
        
        
        //TODO: Update recent
    }
    class func sendMessage(message:LocalMessage,memberIds:[String]){
        RealmManager.shared.saveToRealm(message)
        
        for memberId in memberIds {
            print("save message for \(memberIds)")
        }
    }
    
    
}
func sendTextMessage(message:LocalMessage,text:String,memberIds:[String]){
    message.message = text
    message.type = kTEXT
    OutgoingMessage.sendMessage(message: message, memberIds: memberIds)
}
