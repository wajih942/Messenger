//
//  EditProfileTableViewController.swift
//  Messenger
//
//  Created by wajih on 8/23/22.
//

import UIKit
import Gallery
import ProgressHUD
class EditProfileTableViewController: UITableViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    // MARK: - Vars
    var gallery : GalleryController!
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        configureTextField()
    }
    //we want to refresh every time the user chose a status
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showUserInfo()
        
    }
    // MARK: - TableView Delegates
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableViewBackgroundColor")
        return headerView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 0.0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //show status view
        if indexPath.section == 1 && indexPath.row == 0{
            performSegue(withIdentifier: "editProfileToStatusSeg", sender: self)
        }
        
    }
    // MARK: - UpdateUI
    private func showUserInfo(){
        if let user = User.currentUser{
            usernameTextField.text = user.username
            statusLabel.text = user.status
            if user.avatarLink != ""{
                //set avatar
                FileStorage.downloadImage(imageUrl: user.avatarLink) { avatarImage in
                    self.avatarImageView.image = avatarImage?.circleMasked
                }
            }
        }
    }
    // MARK: - Configure
    private func configureTextField(){
        usernameTextField.delegate = self
    }
    // MARK: - Gallery
    private func showImageGallery(){
        self.gallery = GalleryController()
        //our view will be the delegate of this image gallery
        self.gallery.delegate = self
        Config.tabsToShow = [.imageTab,.cameraTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        self.present(gallery,animated: true,completion:nil)
    }
    
    // MARK: - UploadImages
    
    private func uploadAvatarImage(_ image: UIImage){
        let fileDirectory = "Avatars/" + "_\(User.currentId)" + ".jpg"
        FileStorage.uploadImage(image, directory: fileDirectory) { avatarLink in
            if var user = User.currentUser{
                user.avatarLink = avatarLink ?? ""
                saveUserLocally(user)
                FirebaseUserListener.shared.saveUserToFirestore(user)
            }
            //TODO: save the image locally
            FileStorage.saveFileLocally(fileData: image.jpegData(compressionQuality: 1.0)! as NSData, fileName: User.currentId)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func editButtonPressed(_ sender: Any) {
        showImageGallery()
    }
    
    

}
extension EditProfileTableViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        if textField == usernameTextField{
            if textField.text != "" {
                if var user = User.currentUser {
                    user.username = textField.text!
                    saveUserLocally(user)
                    FirebaseUserListener.shared.saveUserToFirestore(user)
                }
            }
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}

extension EditProfileTableViewController : GalleryControllerDelegate{
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        if images.count > 0 {
            images.first!.resolve { avatar in
                if avatar != nil {
                    // TODO: upload image
                    self.uploadAvatarImage(avatar!)
                    self.avatarImageView.image = avatar?.circleMasked
                }else{
                    ProgressHUD.showError("couldn't select image")
                }
                
            }
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
