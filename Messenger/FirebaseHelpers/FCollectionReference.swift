//
//  FCollectionReference.swift
//  Messenger
//
//  Created by wajih on 8/23/22.
//

import Foundation
import FirebaseFirestore
import Gallery
import SwiftUI

enum FCollectionReference : String{
    case User
    case Recent
    case Messages
}
//using this we can access to a top level folder
func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}

