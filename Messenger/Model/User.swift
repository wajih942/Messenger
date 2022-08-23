//
//  User.swift
//  Messenger
//
//  Created by wajih on 8/22/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

//codable to encode and decode data and equatable is to check if the two users are equal by checking the id
struct User:Codable,Equatable {
    var id = ""
    var username:String
    var email:String
    var pushId = ""
    var avatarLink = ""
    var status : String
    
    static var currentId : String{
        //we are going to access our firebase authentication because
        return Auth.auth().currentUser!.uid
    }
    
    static var currentUser : User?{
        //we are asking firebase if we have a user loged in our app
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.data(forKey: KCURRENTUSER){
                let decoder = JSONDecoder()
                do {
                    let userObject = try decoder.decode(User.self, from: dictionary)
                    return userObject
                } catch  {
                    print("Error decoding user from user defaults",error.localizedDescription)
                }
            }
        }
        return nil
    }
    static func == (lhs:User,rhs:User)->Bool{
        lhs.id == rhs.id
    }
}

func saveUserLocally(_ user:User) {
    let encoder = JSONEncoder()
    do {
        let data = try encoder.encode(user)
        UserDefaults.standard.set(data,forKey: KCURRENTUSER)
    } catch  {
        print("error saving user locally",error.localizedDescription)
    }
}
