//
//  StartChat.swift
//  Messenger
//
//  Created by wajih on 9/2/22.
//

import Foundation
import Firebase
//MARK: - StartChat
//this function will take tow users and will return the chatroom id
// we should create a chat room id which is unique and the same every time tow users want to connect
func startChat(user1:User,user2:User)->String{
    let chatRoomId = chatRoomIdFrom(user1Id: user1.id, user2Id: user2.id)
    createRecentItems(chatRoomId: chatRoomId, users: [user1,user2])
    return chatRoomId
}
func restartChat(chatRoomId:String, membersIds:[String]){
    FirebaseUserListener.shared.downloadUsersFromFirebase(withIds: membersIds) { users in
        if users.count > 0 {
            createRecentItems(chatRoomId: chatRoomId, users: users)
        }
    }
}
func createRecentItems(chatRoomId: String, users:[User]){
    var memberIdsToCreateRecent = [users.first!.id,users.last!.id]
    print("members to create recent is ",memberIdsToCreateRecent)
    FirebaseReference(.Recent).whereField(kCHATROOMID, isEqualTo: chatRoomId).getDocuments { snapshot, error in
        //once we receive our query here we are going to check which these users have recent objects then we will remove it from our members
        //tocrete recent so in the array below we will have users without recent objects
        guard let snapshot = snapshot else {
            return
        }
        if !snapshot.isEmpty {
            memberIdsToCreateRecent = removeMemberWhoHasRecent(snapshot: snapshot, memberIds: memberIdsToCreateRecent)
            print("updated members to create recent is ",memberIdsToCreateRecent)
        }
        for userId in memberIdsToCreateRecent{
            print("creating recent for user with id ", userId)
            let senderUser = userId == User.currentId ? User.currentUser! : getReceiverFrom(users: users)
            let receiverUser = userId == User.currentId ? getReceiverFrom(users: users) : User.currentUser!
            let recentObject = RecentChat(id: UUID().uuidString, chatRoomId: chatRoomId, senderId: senderUser.id, senderName: senderUser.username, receiverId: receiverUser.id, receiverName: receiverUser.username, date: Date(), memberIds: [senderUser.id,receiverUser.id], lastMessage: "", unreadCounter: 0, avatarLink: receiverUser.avatarLink)
            FirebaseRecentListener.shared.saveRecent(recentObject)
        }
    }
}
func removeMemberWhoHasRecent(snapshot:QuerySnapshot,memberIds:[String])->[String]{
    var memberIdsToCreateRecent = memberIds
    for recentData in snapshot.documents{
        let currentRecent = recentData.data() as Dictionary
        if let currentUserId = currentRecent[kSENDERID]{
            if memberIds.contains(currentUserId as! String){
                memberIdsToCreateRecent.remove(at: memberIdsToCreateRecent.firstIndex(of: currentUserId as! String)!)
            }
        }
    }
    return memberIdsToCreateRecent
}
func chatRoomIdFrom(user1Id: String, user2Id:String) -> String{
    var chatRoomId = ""
    // we use this to provide always the same number
    let value = user1Id.compare(user2Id).rawValue
    chatRoomId = value < 0 ? (user1Id + user2Id) : (user2Id + user1Id)
    return chatRoomId
}

func getReceiverFrom(users:[User])->User{
    var allUsers = users
    allUsers.remove(at: allUsers.firstIndex(of: User.currentUser!)!)
    return allUsers.first!
}
