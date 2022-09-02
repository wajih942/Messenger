//
//  UsersTableViewController.swift
//  Messenger
//
//  Created by wajih on 8/29/22.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    // MARK: - Vars
    var allUsers : [User] = []
    var filtredUsers : [User] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    

    //MARK: - View  LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //createDummyUsers()
        self.refreshControl = UIRefreshControl()
        self.tableView.refreshControl = self.refreshControl
        tableView.tableFooterView = UIView()
        setupSearchController()
        downloadUsers()
    }
    
    //this will ensure once we return from users detail we will found our big title
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchController.isActive ? filtredUsers.count : allUsers.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserTableViewCell
        let user = searchController.isActive ? filtredUsers[indexPath.row] : allUsers[indexPath.row]
        cell.configureC(user: user)
        
        return cell
    }
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableViewBackgroundColor")
        return headerView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = searchController.isActive ? filtredUsers[indexPath.row] : allUsers[indexPath.row]
        showUserProfile(user)
    }
    //MARK: - download users
    private func downloadUsers(){
        FirebaseUserListener.shared.downloadAllUsersFromFirebase { allFirebaseUsers in
            self.allUsers = allFirebaseUsers
            print(self.allUsers)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    //MARK: - setupSearchController
    private func setupSearchController(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search user"
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
    }
    private func filtredContentForSearchText(searchText: String){
        filtredUsers = allUsers.filter({ user -> Bool in
            return user.username.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    // MARK: - UIScrollViewDelegate
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.refreshControl!.isRefreshing {
            self.downloadUsers()
            self.refreshControl!.endRefreshing()
        }
    }
    //MARK: - Navigation
    private func showUserProfile(_ user: User){
        let profileView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileView") as! ProfileTableViewController
        profileView.user = user
        self.navigationController?.pushViewController(profileView, animated: true)
    }
}

extension UsersTableViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filtredContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    
}
