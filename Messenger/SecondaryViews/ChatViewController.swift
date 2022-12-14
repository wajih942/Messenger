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
    let titleLabel : UILabel = {
        let title = UILabel(frame: CGRect(x: 5, y: 0, width: 180, height: 25))
        title.textAlignment = .left
        title.font = UIFont.systemFont(ofSize: 16,weight: .medium)
        title.adjustsFontSizeToFitWidth = true
        return title
    }()
    let subTitleLabel :UILabel = {
        let subTitle = UILabel(frame: CGRect(x: 5, y: 22, width: 180, height: 20))
        subTitle.font = UIFont.systemFont(ofSize: 13,weight: .medium)
        subTitle.adjustsFontSizeToFitWidth = true
        return subTitle
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
    
    var displayingMessagesCount = 0
    var maxMessageNumber = 0
    var minMessageNumber = 0

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
        configureMessageCollectionView()
        configureMessageInputBar()
        configureLeftBarButton()
        configureCustomTitle()
        updateTypingIndicator(true)
        loadChats()
        listenForNewChats()
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
        
        updateMicButtonStatus(show: true)
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.backgroundView.backgroundColor = .systemBackground
        messageInputBar.inputTextView.backgroundColor = .systemBackground
        
    }
    
    func updateMicButtonStatus(show:Bool){
        if show {
            messageInputBar.setStackViewItems([micButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
        }else{
            messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 55, animated: false)
        }
    }
    
    private func configureLeftBarButton(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(self.backButtonPressed))
    }
    private func configureCustomTitle(){
        leftBarButtonView.addSubview(titleLabel)
        leftBarButtonView.addSubview(subTitleLabel)
        
        let leftBarButtonItem = UIBarButtonItem(customView: leftBarButtonView)
        self.navigationItem.leftBarButtonItems?.append(leftBarButtonItem)
        titleLabel.text = recipentName
    }
    //MARK: - Load chats
    
    private func loadChats(){
        let predicate = NSPredicate(format: "chatRoomId = %@", chatId)
        allLocalMessages = realm.objects(LocalMessage.self).filter(predicate).sorted(byKeyPath: kDate,ascending: true)
        if allLocalMessages.isEmpty {
            checkForOldChats()
        }
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
    private func listenForNewChats(){
        FirebaseMessageListener.shared.listenForNewChats(User.currentId, collectionId: chatId, lastMessageDate: lastMessageDate())
    }
    private func checkForOldChats(){
        FirebaseMessageListener.shared.checkForOldChats(User.currentId, collectionId: chatId)
    }
    
    
    //MARK: - Insert Messages
    private func insertMessages(){
        maxMessageNumber = allLocalMessages.count - displayingMessagesCount
        minMessageNumber = maxMessageNumber - KNUMBEROFMESSAGES
        
        if minMessageNumber < 0 {
            minMessageNumber = 0
        }
        for i in minMessageNumber ..< maxMessageNumber {
            insertMessage(allLocalMessages[i])
        }
    }
    private func insertMessage(_ localMessage: LocalMessage){
        print("inserted messages")
        let incoming = IncomingMessage(_collectionView: self)
        self.mkMessages.append(incoming.createMessage(localMessage: localMessage)!)
        displayingMessagesCount += 1 
    }
    //MARK: - Actions
    func messageSend(text:String?,photo:UIImage?,video:String?,audio:String?,location:String?,audioDuration: Float = 0.0){
        OutgoingMessage.send(chaId: chatId, text: text, photo: photo, video: video, audio: audio, location: location, memberIds: [User.currentId,recipientId])
    }
    
    @objc func backButtonPressed(){
        
        //TODO: REMOVE LISTENERS
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Update Typing indicator
    func updateTypingIndicator(_ show : Bool){
        subTitleLabel.text = show ? "Typing.." : ""
    }
    
    //MARK: - Helpers
    private func lastMessageDate() -> Date{
        let lastMessageDate = allLocalMessages.last?.date ?? Date()
        return Calendar.current.date(byAdding: .second,value: 1,to: lastMessageDate) ?? lastMessageDate
    }
}
