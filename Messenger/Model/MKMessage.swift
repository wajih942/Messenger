//
//  MKMessage.swift
//  Messenger
//
//  Created by wajih on 9/8/22.
//

import Foundation
import MessageKit
import CoreLocation
class MKMessage : NSObject , MessageType{
    
    var messageId: String
    var kind: MessageKind
    var sentDate: Date
    var incoming:Bool
    var mkSender: MKSender
    var sender: SenderType{
        return mkSender
    }
    var status : String
    var readData : Data
    init(message:String) {
        
    }
    
    
}
