//
//  LocalMessage.swift
//  Messenger
//
//  Created by wajih on 9/8/22.
//

import Foundation
import MessageKit
import RealmSwift

class LocalMessage : Object, Codable {
    @objc dynamic var id = ""
    @objc dynamic var chatRoomId = ""
    @objc dynamic var date = Date()
    @objc dynamic var senderName = ""
    @objc dynamic var id = ""
    
}
