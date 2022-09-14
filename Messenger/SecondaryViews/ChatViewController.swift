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
    
    //MARK: - Views
    let leftBarButtonView : UIView = {
        return UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    }()
    //MARK: - Vars
    private var chatId = ""
    private var recipientId = ""
    private var recipentName = ""
    let currentUser = MKSender(senderId: User.currentId, displayName: User.currentUser!.username)
    let refreshController = UIRefreshControl()
    var mkMessages : [MKMessage] = []
    var allLocalMessages : Results<LocalMessage>!
    let realm = try! Realm()

    let micButton = InputBarButtonItem()
    
    //MARK: Listeners
    var notificationToken : NotificationToken?
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
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = recipentName
        configureMessageCollectionView()
        configureMessageInputBar()
        loadChats()
    }
    
    //MARK: - configurations
    
    private func configureMessageCollectionView(){
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        messagesCollectionView.refreshControl = refreshController
    }
    
    private func configureMessageInputBar(){
        
        messageInputBar.delegate = self
        let attachButton = InputBarButtonItem()
        attachButton.image = UIImage(systemName: "plus",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        attachButton.setSize(CGSize(width: 30, height: 30), animated: false)
        
        attachButton.onTouchUpInside { item in
            print("attach button pressed")
        }
        
        micButton.image = UIImage(systemName: "mic.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        micButton.setSize(CGSize(width: 30, height: 30), animated: false)
        
        //add gesture recognizer
        messageInputBar.setStackViewItems([attachButton], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.backgroundView.backgroundColor = .systemBackground
        messageInputBar.inputTextView.backgroundColor = .systemBackground
        
    }
    //MARK: - Load chats
    
    private func loadChats(){
        let predicate = NSPredicate(format: "chatRoomId = %@", chatId)
        allLocalMessages = realm.objects(LocalMessage.self).filter(predicate).sorted(byKeyPath: kDate,ascending: true)
        
        notificationToken = allLocalMessages.observe({
            (changes:RealmCollectionChange) in
            switch changes {
            case .initial:
                self.insertMessages()
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem(animated: true)
            case .update(_, _, let insertions, _):
                for index in insertions {
                    self.insertMessage(self.allLocalMessages[index])
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToLastItem(animated: false)
                }
                
            case .error(let error):
                print("Error on new insertion ",error.localizedDescription)
            }
        })
    }
    
    private func insertMessages(){
        for message in allLocalMessages {
            insertMessage(message)
        }
    }
    private func insertMessage(_ localMessage: LocalMessage){
        print("inserted messages")
        let incoming = IncomingMessage(_collectionView: self)
        self.mkMessages.append(incoming.createMessage(localMessage: localMessage)!)
    }
    //MARK: - Actions
    func messageSend(text:String?,photo:UIImage?,video:String?,audio:String?,location:String?,audioDuration: Float = 0.0){
        OutgoingMessage.send(chaId: chatId, text: text, photo: photo, video: video, audio: audio, location: location, memberIds: [User.currentId,recipientId])
    }
    

    

}
