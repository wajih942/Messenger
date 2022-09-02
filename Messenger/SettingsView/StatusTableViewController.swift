//
//  StatusTableViewController.swift
//  Messenger
//
//  Created by wajih on 8/28/22.
//

import UIKit

class StatusTableViewController: UITableViewController {
    
    // MARK: - Vars
    var allStatuses : [String] = []
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //THIS WILL GET RID OF EMPTY CELLS
        tableView.tableFooterView = UIView()
        loadUserStatus()
        
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        let status = allStatuses[indexPath.row]
        cell.textLabel?.text = status
        
        cell.accessoryType = User.currentUser?.status == status ? .checkmark : .none
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allStatuses.count
    }
    
    // MARK: - TableViewDelegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        updateCellCheck(indexPath)
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableViewBackgroundColor")
        return headerView
    }
    
    // MARK: - LoadingStatus
    private func loadUserStatus()
    {
        allStatuses = userDefaults.object(forKey: KSTATUS) as!  [String]
        print(allStatuses)
        tableView.reloadData()
    }
    private func updateCellCheck(_ indexPath : IndexPath){
        if var user = User.currentUser{
            user.status = allStatuses[indexPath.row]
            saveUserLocally(user)
            FirebaseUserListener.shared.saveUserToFirestore(user)
        }
    }

}
