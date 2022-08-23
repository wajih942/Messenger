//
//  FirebaseUserListener.swift
//  Messenger
//
//  Created by wajih on 8/23/22.
//

import Foundation
import Firebase
import FirebaseAuth

class FirebaseUserListener {
    static let shared = FirebaseUserListener()
    private init (){
    }
    // MARK: - Login
    func loginUserWithEmail(email:String,password:String,completion:@escaping (_ error : Error?, _ isEmailVerified : Bool)->Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
            if error == nil && authDataResult!.user.isEmailVerified {
                FirebaseUserListener.shared.downloadUserFromFirebase(userId: authDataResult!.user.uid, email: email)
                completion(error,true)
            }else{
                print("email is not verified")
                completion(error,false)
            }
        }
        
    }
    
    
    
    // MARK: - Register
    //the error may occur in a background thread not the main thread the completion is a listener to listen if an error occur
    //the error may be a nil that's the reason we put it optional
    func registerUserWith(email:String,password:String,completion:@escaping(_ error:Error?)->Void){
        Auth.auth().createUser(withEmail: email, password: password) { (authDataRessult, error) in
            completion(error)
            if error == nil {
                //send verification email
                authDataRessult!.user.sendEmailVerification { (error) in
                    print("auth email sent with error",error?.localizedDescription)
                }
                
                //create user and save it
                if authDataRessult?.user != nil {
                    let user = User(id: authDataRessult!.user.uid, username: email, email: email, pushId: "", avatarLink: "", status: "hey i'm using messenger")
                    saveUserLocally(user)
                    self.saveUserToFirestore(user)
                    //we are going to save it in user default 
                }
            }
        }
    }
    
    func resetPasswordFor(email:String,completion : @escaping (_ error: Error?)->Void){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    // MARK: - Save users
    
    func saveUserToFirestore(_ user : User){
        do {
            try FirebaseReference(.User).document(user.id).setData(from: user)
        } catch  {
            print(error.localizedDescription,"adding user")
        }
    }
    // MARK: - Download
    //we may not pass an email we can writte it like that
    func downloadUserFromFirebase(userId:String,email:String?=nil){
        FirebaseReference(.User).document(userId).getDocument { querySnapshot, error in
            guard let document = querySnapshot else {
                print("no document for user")
                //if there is no user we don't need to call the rest of hte code
                return
            }
            
            let result = Result{
                try? document.data(as: User.self)
            }
            switch result {
            case .success(let userObject):
                if let user = userObject{
                    saveUserLocally(user)
                }else{
                    print("Document does not exist")
                }
                
            case .failure(let error):
                print("error decoding user",error)
                
            }
        }
    }
    
    // MARK: - Resend link methods
    func resendVerificationEmail(email:String,completion : @escaping(_ error : Error?)->Void)  {
        Auth.auth().currentUser?.reload(completion: { error in
            Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                completion(error)
            })
        })
    }

    
    
}