//
//  IncomingMessage.swift
//  Messenger
//
//  Created by wajih on 9/13/22.
//

import Foundation
import MessageKit
import CoreLocation

class IncomingMessage{
    var messageCollectionView : MessagesViewController
    init(_collectionView: MessagesViewController) {
        messageCollectionView = _collectionView
    }
    
    //MARK: - CreateMessage
    
    func createMessage(localMessage : LocalMessage) -> MKMessage?{
        let mkMessage = MKMessage(message: localMessage)
        
        //multemedia message
        
        return mkMessage 
    }
}
