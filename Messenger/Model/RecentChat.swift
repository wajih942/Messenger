//
//  RecentChat.swift
//  Messenger
//
//  Created by wajih on 9/1/22.
//

import Foundation
import FirebaseFirestoreSwift

struct RecentChat : Codable {
    var id = ""
    var chatRoomId = ""
    var senderId = ""
    var senderName = ""
    var receiverId = ""
    var receiverName = ""
    //if we don t provide a value for it the server is going to provide a value for it
    @ServerTimestamp var date = Date()
    var memberIds = [""]
    var lastMessage = ""
    var unreadCounter = 0
    var avatarLink = ""
}
