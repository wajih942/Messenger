//
//  FirebaseRecentListener.swift
//  Messenger
//
//  Created by wajih on 9/2/22.
//

import Foundation
import Firebase

class FirebaseRecentListener {
    /*
    A singleton should be used when managing access to a resource which is shared by the entire application, and it would be destructive to potentially have multiple instances of the same class. Making sure that access to shared resources thread safe is one very good example of where this kind of pattern can be vital.*/
    static let shared = FirebaseRecentListener()
    
    private init(){}
    
    func addRecent(_ recent : RecentChat){
        do {
            try FirebaseReference(.Recent).document(recent.id).setData(from: recent)
        } catch  {
            print("Error saving recent chat ", error.localizedDescription)
        }
    }
    
}
