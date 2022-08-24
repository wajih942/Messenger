//
//  SettingsTableTableViewController.swift
//  Messenger
//
//  Created by wajih on 8/23/22.
//

import UIKit

class SettingsTableTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var appVersionLabel: UILabel!
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - TableView Delegates
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableViewBackgroundColor")
        return headerView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 10.0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 0 {
            performSegue(withIdentifier: "settingsToEditProfileSeg", sender: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showUserInfo()
    }
    // MARK: - IBActions
    
    @IBAction func tellAFriendButtonPressed(_ sender: Any) {
        print("tell a friend")
    }
    
    @IBAction func termAndConditionsButtonPressed(_ sender: Any) {
        print("terms and conditions")
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        FirebaseUserListener.shared.logOutCurrentuser { error in
            if error == nil {
                let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginView")
                DispatchQueue.main.async {
                    loginView.modalPresentationStyle = .fullScreen
                    self.present(loginView, animated: true, completion: nil)
                }
            }
            
        }
    }
    
    
    // MARK: - UpdateUI
    private func showUserInfo(){
        if let user = User.currentUser{
            usernameLabel.text = user.username
            statusLabel.text = user.status
            appVersionLabel.text = "   App version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
            if user.avatarLink != "" {
                //download and set avatar image
            }
        }
    }


}
