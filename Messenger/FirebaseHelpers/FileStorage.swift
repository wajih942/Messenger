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
    class func downloadImage(imageUrl:String,completion : @escaping(_ image : UIImage?)-> Void){
        let ImageFileName = fileNameFrom(fileUrl: imageUrl)
        if fileExistsAtPath(path: ImageFileName){
            //get it locally
            print("we have a local image")
            if let contentsOfFile = UIImage(contentsOfFile: fileinDocumentsDirectory(fileName: ImageFileName)){
                completion(contentsOfFile)
            }else{
                print("couldn't convert local image")
                completion(UIImage(named: "avatar"))
            }
        }else{
            //download from fb
            print("let's get from FB")
            
            if imageUrl != "" {
                let documentUrl = URL(string: imageUrl)
                let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
                downloadQueue.async {
                    let data = NSData(contentsOf: documentUrl!)
                    if data != nil {
                        //Save file locally
                        FileStorage.saveFileLocally(fileData: data!, fileName: ImageFileName)
                        //we are on specialm queue we crate to download this image we should return to main
                        DispatchQueue.main.async {
                            completion(UIImage(data: data! as Data))
                        }
                    } else{
                        print("no docment in database")
                        completion(nil)
                    }
                }
            }
        }
    }
    
    //MARK: - Save Locally
    class func saveFileLocally(fileData:NSData,fileName:String){
        let docUrl = getDocumentsURL().appendingPathComponent(fileName, isDirectory: true)
        fileData.write(to: docUrl, atomically: true)//atomically is going to create a temp file once thee override finishs succefully only after it is going to delete the original file
        //if anything was uccefully it is going to replace the old file 
    }
}



//Helpers
// URL IS A VALUE THAT IDENTIFIES THE LOCATION OF A RESSOURCE
func fileinDocumentsDirectory(fileName:String)->String{
    return getDocumentsURL().appendingPathComponent(fileName).path
}
func getDocumentsURL() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
}
//this function will tell as if there is a file with that name with provided path
func fileExistsAtPath(path:String) -> Bool{
    let filePath = fileinDocumentsDirectory(fileName: path)
    let fileManager = FileManager.default
    return fileManager.fileExists(atPath: filePath)
}
