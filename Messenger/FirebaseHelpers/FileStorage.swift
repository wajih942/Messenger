//
//  FileStorage.swift
//  Messenger
//
//  Created by wajih on 8/25/22.
//

import Foundation
import FirebaseStorage
import ProgressHUD

let storage = Storage.storage()

class FileStorage {
    
    //MARK: - Images
    //in the completion we want to return thez link where we save our file
    class func uploadImage(_ image:UIImage,directory:String,completion:@escaping(_ documentLink:String?)->Void){
        //we should convert the image from uiimage to data before uploading it the database
        let storageRef = storage.reference(forURL: KFILEREFRENCE).child(directory)
        
        let imageData = image.jpegData(compressionQuality: 0.6)
        
        var task : StorageUploadTask!
        task = storageRef.putData(imageData!, metadata: nil, completion: { metadata, error in
            //once we upload our image to firebase we still listening for any change so we are going to use line below
            task.removeAllObservers()
            ProgressHUD.dismiss()
            
            if(error != nil){
                print("error uploading image \(error!.localizedDescription)")
                return
            }
            storageRef.downloadURL { url, error in
                guard let downloadUrl = url else{
                    completion(nil)
                    return
                }
                completion(downloadUrl.absoluteString)
            }
        })
        
        task.observe(StorageTaskStatus.progress) { snapshot in
            let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
            ProgressHUD.showProgress(CGFloat(progress))
        }
    }
}


//Helpers
// URL IS A VALUE THAT IDENTIFIES THE LOCATION OF A RESSOURCE
func getDocumentsURL() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
}
