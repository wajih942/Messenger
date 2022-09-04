//
//  ChatViewController.swift
//  Messenger
//
//  Created by wajih on 9/4/22.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Gallery
import RealmSwift
class ChatViewController: MessagesViewController {
    
    
    //MARK: - Vars
    private var chatId = ""
    private var recipientId = ""
    private var recipentName = ""
    
    //MARK: - Inits
    init(chatId : String, recipientId: String, recipientName: String) {
        //we want to initialize our super view
        super.init(nibName: nil, bundle: nil)
        self.chatId = chatId
        self.recipientId = recipientId
        self.recipentName = recipientName
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    

}
