//
//  MessageDataSource.swift
//  Messenger
//
//  Created by wajih on 9/4/22.
//

import Foundation
import MessageKit
extension ChatViewController : MessagesDataSource{
    
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return mkMessages[indexPath.row]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return mkMessages.count
    }
    
    
}
